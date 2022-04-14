-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGANEXOYFAPREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGANEXOYFAPREP`;
DELIMITER $$


CREATE PROCEDURE `REGANEXOYFAPREP`(
-- ============================================================================================================
-- ------------------ SP PARA OBTENER DATOS DEL ANEXO Y FAP -----------------------
-- ============================================================================================================
	Par_Fecha           DATETIME,			-- Fecha de generacion del reporte
	Par_NumReporte      TINYINT UNSIGNED,	-- Tipo de reporte 1: Excel 2: CVS
	Par_NumDecimales    INT,				-- Numero de Decimales en Cantidades o Montos

    Par_EmpresaID       INT,
    Aud_Usuario         INT,
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT
	)

TerminaStore: BEGIN
	-- Variables
	DECLARE Var_Periodo 		VARCHAR(8);
	DECLARE Var_ClaveEntidad 	VARCHAR(10);
	DECLARE Var_NumCliente		INT;
	DECLARE Var_TipoInsti		CHAR(3);
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



	SET NumReporte			:= 'ANEXO';				-- Clave del reporte
	SET Entero_Cero			:= 0;
	SET Cadena_Vacia 		:= '';
	SET Con_CliProcEspe     := 'CliProcEspecifico';	-- Llave para obtener el numero del cliente
	SET Con_TipoRegula    	:= 'TipoRegulatorios';  -- llave para obtener el Tipo de Regulatorios
	SET Var_TipoInsti		:= '000'; 				-- Valor DEFAULT para la llamada del regulatorio
	SET Resp_SI				:= 'S';
	SET Resp_NO				:= 'N';
    SET Var_NumCliReg       := 24 ;

	-- Numero del Cliente
	SELECT IFNULL(ValorParametro, Entero_Cero)
		INTO 	Var_NumCliente
		FROM 	PARAMGENERALES
		WHERE 	LlaveParametro = Con_CliProcEspe;


	SELECT CASE WHEN FIND_IN_SET(Var_NumCliente,Ins.Especiales) > Entero_Cero THEN Resp_SI ELSE Resp_NO END
		INTO 	Var_EsEspecial
		FROM 	REGULATORIOSINS Ins
        WHERE 	Clave = NumReporte;

	IF(Var_EsEspecial = Resp_SI) THEN
		SET Var_NumCliReg := LPAD(Var_NumCliente,2,Entero_Cero);
	END IF;


-- CCPV024REP
-- REGANEXO00024REP
-- REG ANEXO 000 24 REP

	SET Var_NombreReporte := CONCAT('REG', NumReporte,Var_TipoInsti,LPAD(Var_NumCliReg,2,Entero_Cero),'REP');


	SET Var_Llamada := CONCAT(' CALL ',Var_NombreReporte,
		"('",Par_Fecha,"',",Par_NumReporte,',',Par_NumDecimales,',',Par_EmpresaID,',',Aud_Usuario,',',"'",Aud_FechaActual,"'",',',"'",Aud_DireccionIP,"'",',',"'",Aud_ProgramaID,"'",',',Aud_Sucursal,',',Aud_NumTransaccion,');');

	SET @Sentencia    = (Var_Llamada);
	PREPARE EjecutaProc FROM @Sentencia;
	EXECUTE  EjecutaProc;
	DEALLOCATE PREPARE EjecutaProc;



END TerminaStore$$