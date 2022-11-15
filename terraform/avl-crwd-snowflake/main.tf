
resource "snowflake_table" "crowdstrike_fdr" {
  provider = snowflake.account_admin
  database            = var.anvilogic_db_name
  schema              = var.staging_schema_name
  name                = "CROWDSTRIKE_FDR"
  comment             = "Table for staging Crowdtrike FDR data. Created by Anvilogic via Terraform."

  column {
    name     = "raw_data"
    type     = "VARIANT"
  }

  column {
    name     = "event_simple_name"
    type     = "string"
  }
}

resource "snowflake_table" "crowdstrike_fdr_processrollup" {
  provider = snowflake.account_admin
  database            = var.anvilogic_db_name
  schema              = var.data_source_schema_name
  name                = "CROWDSTRIKE_FDR_PROCESSROLLUP"
  comment             = "Table for Crowdtrike FDR processrollup data. Created by Anvilogic via Terraform."
  cluster_by          = ["EVENT_PLATFORM"]

  column {
    name     = "insert_id"
    type     = "NUMBER(38,0)"
    nullable = true

    identity {
      start_num = 1
      step_num  = 1
    }
  }

  column {
    name = "insert_time"
    type = "TIMESTAMP_NTZ(9)"
  }

  column {
    name     = "raw"
    type     = "string"
  }

  column {
    name     = "hash_raw"
    type     = "string"
  }

  column {
    name     = "event_time"
    type     = "TIMESTAMP_NTZ(9)"
  }
  
  column {
    name     = "command_line"
    type     = "string"
  }
  
  column {
    name     = "config_build"
    type     = "string"
  }

  column {
    name     = "config_state_hash"
    type     = "string"
  }

  column {
    name     = "effective_transmission_class"
    type     = "string"
  }

  column {
    name     = "entitlements"
    type     = "string"
  }

  column {
    name     = "gid"
    type     = "string"
  }

  column {
    name     = "image_file_name"
    type     = "string"
  }

  column {
    name     = "md5_hash_data"
    type     = "string"
  }

  column {
    name     = "parent_base_file_name"
    type     = "string"
  }

  column {
    name     = "parent_process_id"
    type     = "string"
  }

  column {
    name     = "process_end_time"
    type     = "string"
  }

  column {
    name     = "process_group_id"
    type     = "string"
  }

  column {
    name     = "process_start_time"
    type     = "string"
  }

  column {
    name     = "rgid"
    type     = "string"
  }

  column {
    name     = "ruid"
    type     = "string"
  }

  column {
    name     = "raw_process_id"
    type     = "string"
  }

  column {
    name     = "sha1_hash_data"
    type     = "string"
  }

  column {
    name     = "sha256_hash_data"
    type     = "string"
  }

  column {
    name     = "svgid"
    type     = "string"
  }

  column {
    name     = "svuid"
    type     = "string"
  }

  column {
    name     = "session_process_id"
    type     = "string"
  }

  column {
    name     = "source_process_id"
    type     = "string"
  }

  column {
    name     = "source_thread_id"
    type     = "string"
  }

  column {
    name     = "tags"
    type     = "string"
  }

  column {
    name     = "target_process_id"
    type     = "string"
  }

  column {
    name     = "uid"
    type     = "string"
  }

  column {
    name     = "aid"
    type     = "string"
  }

  column {
    name     = "aip"
    type     = "string"
  }

  column {
    name     = "cid"
    type     = "string"
  }

  column {
    name     = "EVENT_PLATFORM"
    type     = "string"
  }

  column {
    name     = "event_simple_name"
    type     = "string"
  }

  column {
    name     = "id"
    type     = "string"
  }

  column {
    name     = "name"
    type     = "string"
  }

  column {
    name     = "timestamp"
    type     = "string"
  }

}

resource "snowflake_table" "crowdstrike_fdr_identity" {
  provider = snowflake.account_admin
  database            = var.anvilogic_db_name
  schema              = var.data_source_schema_name
  name                = "CROWDSTRIKE_FDR_IDENTITY"
  comment             = "Table for Crowdtrike FDR identity data. Created by Anvilogic via Terraform."

  column {
    name = "insert_time"
    type = "TIMESTAMP_NTZ(9)"
  }

  column {
    name     = "hash"
    type     = "string"
  }

  column {
    name     = "user_is_admin"
    type     = "string"
  }

  column {
    name     = "username"
    type     = "string"
  }

  column {
    name     = "user_principal"
    type     = "string"
  }

  column {
    name     = "uid"
    type     = "string"
  }

  column {
    name     = "aid"
    type     = "string"
  }

  column {
    name     = "event_simple_name"
    type     = "string"
  }
}

resource "snowflake_table" "crowdstrike_fdr_asset" {
  provider = snowflake.account_admin
  database            = var.anvilogic_db_name
  schema              = var.data_source_schema_name
  name                = "CROWDSTRIKE_FDR_ASSET"
  comment             = "Table for Crowdtrike FDR identity data. Created by Anvilogic via Terraform."

  column {
    name = "insert_time"
    type = "TIMESTAMP_NTZ(9)"
  }

  column {
    name     = "hash"
    type     = "string"
  }

  column {
    name     = "computer_name"
    type     = "string"
  }

  column {
    name     = "machine_domain"
    type     = "string"
  }

  column {
    name     = "ou"
    type     = "string"
  }

  column {
    name     = "site_name"
    type     = "string"
  }

  column {
    name     = "falcon_grouping_tags"
    type     = "string"
  }

  column {
    name     = "city"
    type     = "string"
  }

  column {
    name     = "country"
    type     = "string"
  }

  column {
    name     = "product_type"
    type     = "string"
  }

  column {
    name     = "system_manufacturer"
    type     = "string"
  }

  column {
    name     = "system_product_name"
    type     = "string"
  }

  column {
    name     = "aid"
    type     = "string"
  }

  column {
    name     = "aip"
    type     = "string"
  }

  column {
    name     = "platform"
    type     = "string"
  }
}

resource "snowflake_table_grant" "processrollup_grant" {
  provider          = snowflake.security_admin
  database_name     = var.anvilogic_db_name
  schema_name       = var.data_source_schema_name
  table_name        = snowflake_table.crowdstrike_fdr_processrollup.name  
  privilege         = "SELECT"
  roles             = [var.avl_role_name]
  with_grant_option = false
}

resource "snowflake_table_grant" "identity_grant" {
  provider          = snowflake.security_admin
  database_name     = var.anvilogic_db_name
  schema_name       = var.data_source_schema_name
  table_name        = snowflake_table.crowdstrike_fdr_identity.name

  privilege         = "SELECT"
  roles             = [var.avl_role_name]
  with_grant_option = false
}

resource "snowflake_table_grant" "asset_grant" {
  provider          = snowflake.security_admin
  database_name     = var.anvilogic_db_name
  schema_name       = var.data_source_schema_name
  table_name        = snowflake_table.crowdstrike_fdr_asset.name

  privilege         = "SELECT"
  roles             = [var.avl_role_name]
  with_grant_option = false
}

resource "snowflake_file_format" "fdr_stage_format" {
  provider = snowflake.account_admin
  name        = "FDR_STAGE_FORMAT"
  database    = var.anvilogic_db_name
  schema      = var.staging_schema_name
  format_type = "JSON"
  strip_outer_array = true

  # Default values required to be explicitly stated
  compression = "AUTO"
  binary_format = "HEX"
}

resource "time_sleep" "format_to_stage" {
  depends_on = [snowflake_file_format.fdr_stage_format]
  create_duration = "5s"
}

resource "snowflake_stage" "crowdstrike_fdr_stage" {
  provider = snowflake.account_admin
  depends_on = [time_sleep.format_to_stage]
  name        = "CROWDSTRIKE_FDR_STAGE"
  url         = "s3://${var.crwd_log_bucket_name}/logs"
  database    = var.anvilogic_db_name
  schema      = var.staging_schema_name

  file_format = "FORMAT_NAME = ${var.anvilogic_db_name}.${var.staging_schema_name}.FDR_STAGE_FORMAT"
  storage_integration = var.s3_integration_name
}

resource "time_sleep" "stage_to_pipe" {
  depends_on = [ snowflake_stage.crowdstrike_fdr_stage ]
  create_duration = "10s"
}

resource "snowflake_pipe" "crowdstrike_fdr_pipe" {
  provider = snowflake.account_admin
  depends_on = [time_sleep.stage_to_pipe]
  database = var.anvilogic_db_name
  schema   = var.staging_schema_name
  name     = "CROWDSTRIKE_FDR_PIPE"

  comment = "Pipe for ingesting Crowdstrike FDR logs.  Created by Anvilogic via Terraform."

  copy_statement = <<EOS
        copy into ${var.anvilogic_db_name}.${var.staging_schema_name}.${snowflake_table.crowdstrike_fdr.name} 
        from ( select
            $1 as raw,
            $1:event_simpleName::string as event_simple_name
        from @${var.anvilogic_db_name}.${var.staging_schema_name}.${snowflake_stage.crowdstrike_fdr_stage.name} )
        EOS
  auto_ingest    = true
}

resource "snowflake_stream" "crowdstrike_fdr_stream_processrollup" {
  provider = snowflake.account_admin
  database = var.anvilogic_db_name
  schema   = var.staging_schema_name
  name     = "CROWDSTRIKE_FDR_STREAM_PROCESSROLLUP"

  comment = "Stream for processrollup logs. Created by Anvilogic via Terraform."
  on_table    = "${var.anvilogic_db_name}.${var.staging_schema_name}.${snowflake_table.crowdstrike_fdr.name}"
}

resource "snowflake_stream" "crowdstrike_fdr_stream_identity" {
  provider = snowflake.account_admin
  database = var.anvilogic_db_name
  schema   = var.staging_schema_name
  name     = "CROWDSTRIKE_FDR_STREAM_IDENTITY"

  comment = "Stream for identity logs. Created by Anvilogic via Terraform."
  on_table    = "${var.anvilogic_db_name}.${var.staging_schema_name}.${snowflake_table.crowdstrike_fdr.name}"
}

resource "snowflake_stream" "crowdstrike_fdr_stream_asset" {
  provider = snowflake.account_admin
  database = var.anvilogic_db_name
  schema   = var.staging_schema_name
  name     = "CROWDSTRIKE_FDR_STREAM_ASSET"

  comment = "Stream for asset logs. Created by Anvilogic via Terraform."
  on_table    = "${var.anvilogic_db_name}.${var.staging_schema_name}.${snowflake_table.crowdstrike_fdr.name}"
}

resource "snowflake_task" "crowdstrike_fdr_task_processrollup" {
  comment = "Task for processing processrollup logs. Created by Anvilogic via Terraform."
  depends_on = [time_sleep.stage_to_pipe]
  provider = snowflake.account_admin
  
  database = var.anvilogic_db_name
  schema   = var.staging_schema_name
  warehouse = var.task_warehouse_name

  name          = "CROWDSTRIKE_FDR_TASK_PROCESSROLLUP"
  schedule      = var.processrollup_task_schedule
  sql_statement = <<EOT
    insert into ${var.anvilogic_db_name}.${var.data_source_schema_name}.${snowflake_table.crowdstrike_fdr_processrollup.name} (
      insert_time, raw, hash_raw, event_time, command_line, config_build, config_state_hash, effective_transmission_class, entitlements, 
      gid, image_file_name, md5_hash_data, parent_base_file_name, parent_process_id, process_end_time, process_group_id, 
      process_start_time, rgid, ruid, raw_process_id, sha1_hash_data, sha256_hash_data, svgid, svuid, session_process_id, 
      source_process_id, source_thread_id, tags, target_process_id, uid, aid, aip, cid, event_platform, event_simple_name, 
      id, name, timestamp
    )
    select 
        current_timestamp() as insert_time,
        raw_data as raw,
        hash(raw_data) as hash_raw,
        coalesce(try_to_timestamp(raw_data:timestamp::string), current_timestamp()) as event_time,
        raw_data:CommandLine::string as command_line,
        raw_data:ConfigBuild::string as config_build,
        raw_data:ConfigStateHash::string as config_state_hash,
        raw_data:EffectiveTransmissionClass::string as effective_transmission_class,
        raw_data:Entitlements::string as entitlements,
        raw_data:GID::string as gid,
        raw_data:ImageFileName::string as image_file_name,
        raw_data:MD5HashData::string as md5_hash_data,
        raw_data:ParentBaseFileName::string as parent_base_file_name,
        raw_data:ParentProcessId::string as parent_process_id,
        raw_data:ProcessEndTime::string as process_end_time,
        raw_data:ProcessGroupId::string as process_group_id,
        raw_data:ProcessStartTime::string as process_start_time,
        raw_data:RGID::string as rgid,
        raw_data:RUID::string as ruid,
        raw_data:RawProcessId::string as raw_process_id,
        raw_data:SHA1HashData::string as sha1_hash_data,
        raw_data:SHA256HashData::string as sha256_hash_data,
        raw_data:SVGID::string as svgid,
        raw_data:SVUID::string as svuid,
        raw_data:SessionProcessId::string as session_process_id,
        raw_data:SourceProcessId::string as source_process_id,
        raw_data:SourceThreadId::string as source_thread_id,
        raw_data:Tags::string as tags,
        raw_data:TargetProcessId::string as target_process_id,
        coalesce(raw_data:UserSid::string, raw_data:UID::string) as uid,
        raw_data:aid::string as aid,
        raw_data:aip::string as aip,
        raw_data:cid::string as cid,
        raw_data:event_platform::string as event_platform,
        event_simple_name,
        raw_data:id::string as id,
        raw_data:name::string as name,
        raw_data:timestamp::string as timestamp
    from ${var.anvilogic_db_name}.${var.staging_schema_name}.${snowflake_stream.crowdstrike_fdr_stream_processrollup.name}
    where event_simple_name = 'ProcessRollup2';
    EOT
  enabled       = var.tasks_enabled
}

resource "snowflake_task" "crowdstrike_fdr_task_identity" {
  comment = "Task for processing FDR identity logs. Created by Anvilogic via Terraform."
  depends_on = [time_sleep.stage_to_pipe]
  provider = snowflake.account_admin

  database = var.anvilogic_db_name
  schema   = var.staging_schema_name
  warehouse = var.task_warehouse_name

  # session_parameters = {"ERROR_ON_NONDETERMINISTIC_MERGE" : "false"}

  name          = "CROWDSTRIKE_FDR_TASK_IDENTITY"
  schedule      = var.identity_task_schedule
  enabled       = var.tasks_enabled
  
  sql_statement = <<EOT
    merge into ${var.anvilogic_db_name}.${var.data_source_schema_name}.${snowflake_table.crowdstrike_fdr_identity.name} as identity
    using (
        select distinct
            current_timestamp() as insert_time,
            hash(concat(raw_data:aid::string, coalesce(raw_data:UserSid::string, raw_data:UID::string))) as hash,
            raw_data:UserIsAdmin::string as user_is_admin,
            raw_data:UserName::string as username,
            raw_data:UserPrincipal::string as user_principal,
            coalesce(raw_data:UserSid::string, raw_data:UID::string) as uid,
            raw_data:aid::string as aid,
            event_simple_name
        from ${var.anvilogic_db_name}.${var.staging_schema_name}.${snowflake_stream.crowdstrike_fdr_stream_identity.name}
        where event_simple_name = 'UserIdentity' ) as stage on identity.hash = stage.hash
    when matched then update set 
        insert_time = stage.insert_time,
        user_is_admin = stage.user_is_admin,
        username = stage.username,
        user_principal = stage.user_principal
    when not matched then insert
        ( insert_time, hash, user_is_admin, username, user_principal, uid, aid, event_simple_name )
        values
        ( stage.insert_time, stage.hash, stage.user_is_admin, stage.username, stage.user_principal, stage.uid, stage.aid, stage.event_simple_name );
    EOT
}

resource "snowflake_task" "crowdstrike_fdr_task_asset" {
  comment = "Task for processing FDR asset logs. Created by Anvilogic via Terraform."
  depends_on = [time_sleep.stage_to_pipe]
  provider = snowflake.account_admin

  database = var.anvilogic_db_name
  schema   = var.staging_schema_name
  warehouse = var.task_warehouse_name

  # session_parameters = {"error_on_nondeterministic_merge" : var.false_value }

  name          = "CROWDSTRIKE_FDR_TASK_ASSET"
  schedule      = var.asset_task_schedule

  sql_statement = <<EOT
    merge into ${var.anvilogic_db_name}.${var.data_source_schema_name}.${snowflake_table.crowdstrike_fdr_asset.name} as asset
    using (
        select distinct
            current_timestamp() as insert_time,
            hash(raw_data:aid::string) as hash,
            raw_data:ComputerName::string as computer_name,
            raw_data:MachineDomain::string as machine_domain,
            raw_data:OU::string as ou,
            raw_data:SiteName::string as site_name,
            raw_data:FalconGroupingTags::string as falcon_grouping_tags,
            raw_data:City::string as city,
            raw_data:Country::string as country,
            raw_data:ProductType::string as product_type,
            raw_data:SystemManufacturer::string as system_manufacturer,
            raw_data:SystemProductName::string as system_product_name,
            raw_data:aid::string as aid,
            raw_data:aip::string as aip,
            raw_data:event_platform::string as platform
        from ${var.anvilogic_db_name}.${var.staging_schema_name}.${snowflake_stream.crowdstrike_fdr_stream_asset.name}
        where computer_name is not null ) as stage on asset.hash = stage.hash
    when matched then update set 
        insert_time = stage.insert_time,
        computer_name = stage.computer_name,
        machine_domain = stage.machine_domain,
        ou = stage.ou,
        site_name = stage.site_name,
        falcon_grouping_tags = stage.falcon_grouping_tags,
        city = stage.city,
        country = stage.country,
        product_type = stage.product_type,
        system_manufacturer = stage.system_manufacturer,
        system_product_name = stage.system_product_name,
        aip = stage.aip,
        platform = stage.platform
    when not matched then insert
        ( insert_time, hash, computer_name, machine_domain, ou, site_name, falcon_grouping_tags, city, country, product_type, system_manufacturer, system_product_name, aid, aip, platform )
        values
        ( stage.insert_time, stage.hash, stage.computer_name, stage.machine_domain, stage.ou, stage.site_name, stage.falcon_grouping_tags, stage.city, stage.country, stage.product_type, stage.system_manufacturer, stage.system_product_name, stage.aid, stage.aip, stage.platform ); 
  EOT

  enabled       = var.tasks_enabled
}