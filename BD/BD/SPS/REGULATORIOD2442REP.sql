-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGULATORIOD2442REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGULATORIOD2442REP`;DELIMITER $$

CREATE PROCEDURE `REGULATORIOD2442REP`(
# ------------------------------------------------------------------------------------------- #
# - SP QUE GENERA EL REPORTE EN EXCEL Y CSV PARA EL REGULATORIO D 2442 ---------------------- #
# ------------------------------------------------------------------------------------------- #
    Par_Anio                INT,            -- Ano del reporte
    Par_Trimestre           INT,            -- Trimestre a reportar
    Par_TipoReporte         INT,            -- Tipo de Reporte Excel(1) o CSV(2)
    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),

    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
)
TerminaStore:BEGIN
    	-- Variables
	DECLARE Var_Periodo 		VARCHAR(8);
	DECLARE Var_ClaveEntidad 	VARCHAR(10);
	DECLARE Var_NumCliente		INT;
	DECLARE Var_TipoInsti		INT;
	DECLARE Var_EsEspecial		CHAR(1);
	DECLARE Var_NumCliReg		VARCHAR(3);
	DECLARE Var_NombreReporte	VARCHAR(29);
	DECLARE Var_llamada 		VARCHAR(400);

	-- Constantes
	DECLARE NumReporte			VARCHAR(7);
	DECLARE Entero_Cero			INT;
	DECLARE Cadena_Vacia 		VARCHAR(2);
	DECLARE Resp_SI 			CHAR(1);
	DECLARE Resp_NO 			CHAR(1);
   	DECLARE Con_CliProcEspe     VARCHAR(20);
   	DECLARE Con_TipoRegula      VARCHAR(20);



	SET NumReporte			:= 'D2442';					-- Clave del reporte
	SET Entero_Cero			:= 0;
	SET Cadena_Vacia 		:= '';
	SET Con_CliProcEspe     := 'CliProcEspecifico';	-- Llave para obtener el numero del cliente
	SET Con_TipoRegula    	:= 'TipoRegulatorios';  -- llave para obtener el Tipo de Regulatorios
	SET Var_NumCliReg		:= '000'; 				-- Valor DEFAULT para la llamada del regulatorio
	SET Resp_SI				:= 'S';
	SET Resp_SI				:= 'N';

	-- Numero del Cliente
	SELECT IFNULL(ValorParametro, Entero_Cero)
		INTO 	Var_NumCliente
		FROM 	PARAMGENERALES
		WHERE 	LlaveParametro = Con_CliProcEspe;

	-- Tipo de Regulatorios
	SELECT IFNULL(ValorParametro, Entero_Cero)
		INTO 	Var_TipoInsti
		FROM 	PARAMGENERALES
		WHERE 	LlaveParametro = Con_TipoRegula;

	SELECT CASE WHEN FIND_IN_SET(Var_NumCliente,Ins.Especiales) > Entero_Cero THEN Resp_SI ELSE Resp_NO END
		INTO 	Var_EsEspecial
		FROM 	REGULATORIOSINS Ins
        WHERE 	Clave = NumReporte;

	IF(Var_EsEspecial = Resp_SI) THEN
		SET Var_NumCliReg := LPAD(Var_NumCliente,3,Entero_Cero);
	END IF;

	SET Var_NombreReporte := CONCAT('REG', NumReporte,Var_NumCliReg,LPAD(Var_TipoInsti,2,Entero_Cero),'REP');

	SET Var_Llamada := CONCAT(' CALL ',Var_NombreReporte,
		'(',Par_Anio,',',Par_Trimestre,',',Par_TipoReporte,',',Par_EmpresaID,',',Aud_Usuario,',',"'",Aud_FechaActual,"'",',',"'",Aud_DireccionIP,"'",',',"'",Aud_ProgramaID,"'",',',Aud_Sucursal,',',Aud_NumTransaccion,');');


	SET @Sentencia    = (Var_Llamada);
	PREPARE EjecutaProc FROM @Sentencia;
	EXECUTE  EjecutaProc;
	DEALLOCATE PREPARE EjecutaProc;


END TerminaStore$$