﻿Invoke-Sqlcmd -Query "SELECT is_broker_enabled FROM sys.databases WHERE name = 'ETL_Controller';" -ServerInstance "MSLT-319\LEXBI_DI03_16PPE" 