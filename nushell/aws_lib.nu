let aws_profile = $env.AWS_PROFILE
let parts = ($aws_profile | split row "-")
let aws_region_prefix = $parts.0
let aws_env = $parts.1

let region = if $aws_region_prefix == "eu" {
    $env.EU_REGION
} else if $aws_region_prefix == "us" {
    $env.US_REGION
} else {
    error make { msg: $"Unknown region prefix: ($aws_region_prefix)" }
}

def nu-aws-jobs-runs [job_name: string, max_results?: int ] {
  aws glue get-job-runs --job-name $job_name --max-results ($max_results | default 55)
  | from json
  | get JobRuns
  | each {|row|
        {
            Id: $row.Id,
            StartedOn: ($row.StartedOn | into datetime),
            ExecutionTime: ($row.ExecutionTime | into duration --unit sec),
            JobRunState: $row.JobRunState,
            Arguments: $row.Arguments
        }
    }
}

def nu-aws-ls [folder?: string] {
  let base_path: string = $"s3://($env.PROJECT_ENV)-($aws_env)-($region)-($env.DATA_OWNER)-($env.PROJECT_NAME)"
  let s3_path: string = if $folder != null { $"($base_path)/($folder)/" } else { $base_path }

  aws s3 ls $s3_path --recursive --human-readable
  | detect columns --no-headers
  | update column0 {|row| $"($row.column0) ($row.column1)" }
  | update column2 {|row| $"($row.column2) ($row.column3)" }
  | select column0 column2 column4
  | rename modified-date file-size aws-s3-path
  | update aws-s3-path {|row| $"($base_path)/($row.aws-s3-path)" }
}

def nu-aws-get-secrets [secret_id : string] {
  aws secretsmanager get-secret-value --secret-id $secret_id 
  | from json 
  | get SecretString
  | from json
}
 
