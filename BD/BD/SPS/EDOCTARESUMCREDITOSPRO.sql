-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTARESUMCREDITOSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTARESUMCREDITOSPRO`;DELIMITER $$

CREATE PROCEDURE `EDOCTARESUMCREDITOSPRO`(
# ==============================================================
# -- SP PARA GENERAR INFORMACION DE RESUMEN DE CREDITOS --------
# -- PARA EL ESTADO DE CUENTA ----------------------------------
# ==============================================================
  Par_AnioMes     INT(11),    # Anio y Mes
    Par_SucursalID  INT(11),    # Numero de Sucursal
    Par_FecIniMes   DATE,     # Fecha Inicio Mes
    Par_FecFinMes   DATE      # Fecha Fin Mes

  )
TerminaStore: BEGIN

  # Declaracion de variables
  DECLARE Var_CliProEsp       INT(11);    # Almacena el Numero de Cliente para Procesos Especificos
  DECLARE Var_Llamada       VARCHAR(400); # Almacena la llamada a realizar el proceso
  DECLARE Var_ProcPersonalizado   VARCHAR(200);   # Almacena el nombre del SP para generar los detalles de los creditos
  DECLARE Var_CliProEspEdoCta   INT(11);    -- Almacena el Numero de Cliente para Procesos Especificos de estado de cuenta

  # Declaracion de constantes
  DECLARE Entero_Cero       INT(11);      # Entero Cero
  DECLARE Cadena_Vacia    CHAR(1);      # Cadena Vacia
  DECLARE ResumeCreEdoCta   INT(11);      # Identificador Resumen de Creditos para el Estado de Cuenta
  DECLARE Con_CliProcEspe     VARCHAR(20);    # Numero de Cliente para Procesos Especificos
  DECLARE NumClienteSofi    INT(11);      # Numero de Cliente para Sofi Express Procesos Especificos: 15

  DECLARE NumClienteCONSOL  INT(11);      # Numero de Cliente para CONSOL Procesos Especificos: 10
  DECLARE NumClienteCred    INT(11);      -- Numero de Cliente para Crediclub Proceso Especifico:24
  DECLARE NumClienteNuevo   INT(11);      -- Numero de Cliente para clientes nuevos Proceso Especifico:99
  DECLARE Con_EdoCtaGral    VARCHAR(20);    -- Numero de Cliente para Procesos Especificos de estado de cuenta

  # Asignacion de constantes
  SET Entero_Cero     := 0;         # Entero Cero
  SET Cadena_Vacia    := '';          # Cadena Vacia
  SET ResumeCreEdoCta   := 7;         # Identificador Resumen de Creditos para el Estado de Cuenta
  SET Con_CliProcEspe     := 'CliProcEspecifico'; # Numero de Cliente para Procesos Especificos
  SET NumClienteSofi    := 15;          # Numero de Cliente para Sofi Express Procesos Especificos: 15

  SET NumClienteCONSOL  := 10;          # Numero de Cliente para CONSOL Procesos Especificos: 10
  SET NumClienteCred    := 24;          -- Numero de Cliente para Crediclub Proceso Especifico:24
  SET NumClienteNuevo   := 99;          -- Numero de cliente  para todos los clientes nuevos Procesos Especificos: 99
  SET Con_EdoCtaGral    := 'EdoCtaGeneral';   -- Numero de Cliente para Procesos Especificos de estado de cuenta

ManejoErrores:BEGIN

  # Se obtiene el Numero de Cliente para Procesos Especificos
  SET Var_CliProEsp :=  (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = Con_CliProcEspe);

  SET Var_CliProEsp := IFNULL(Var_CliProEsp,Entero_Cero);

  -- Se obtiene el Numero de Cliente para Procesos Especificos de Estado de Cuenta
  SET Var_CliProEspEdoCta :=  (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = Con_EdoCtaGral);

  SET Var_CliProEspEdoCta := IFNULL(Var_CliProEspEdoCta,Entero_Cero);

    /* Se obtiene el nombre del SP a realizar el proceso */
  IF(Var_CliProEsp = NumClienteSofi) THEN
    SET Var_ProcPersonalizado := (SELECT NomProc FROM CATPROCEDIMIENTOS WHERE ProcedimientoID = ResumeCreEdoCta AND CliProEspID = Var_CliProEsp);
  ELSEIF (Var_CliProEsp = NumClienteCred) THEN
      SET Var_ProcPersonalizado = (SELECT NomProc FROM CATPROCEDIMIENTOS WHERE ProcedimientoID = ResumeCreEdoCta AND CliProEspID = Var_CliProEsp);
  ELSEIF(Var_CliProEspEdoCta = NumClienteNuevo)THEN
        SET Var_ProcPersonalizado := (SELECT NomProc FROM CATPROCEDIMIENTOS WHERE ProcedimientoID = ResumeCreEdoCta AND CliProEspID = Var_CliProEspEdoCta);
    ELSE
    SET Var_ProcPersonalizado := (SELECT NomProc FROM CATPROCEDIMIENTOS WHERE ProcedimientoID = ResumeCreEdoCta AND CliProEspID = Entero_Cero);
  END IF;

  /* Se realiza la llamada al SP para realizar el proceso
   de los detalles de movimientos de creditos */
   SET Var_Llamada := CONCAT(' CALL ', Var_ProcPersonalizado,' (',Par_AnioMes,',',Par_SucursalID,',',"'",Par_FecIniMes,"'",",","'",Par_FecFinMes,"'",");");

  # Se ejecuta la sentencia del proceso
  SET @Sentencia    := (Var_Llamada);
  PREPARE EjecutaProc FROM @Sentencia;
  EXECUTE  EjecutaProc;
  DEALLOCATE PREPARE EjecutaProc;

END ManejoErrores;


END TerminaStore$$