-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGULATORIOA2111REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGULATORIOA2111REP`;DELIMITER $$

CREATE PROCEDURE `REGULATORIOA2111REP`(
-- ---------------------------------------------------------------------------------
-- Genera la llamada para el reporte A2111
-- ---------------------------------------------------------------------------------
	Par_Anio           		INT,				-- Ano
	Par_Mes					INT,				-- Mes
	Par_NumRep				TINYINT UNSIGNED, 	-- Numero de reporte

    Par_EmpresaID       	INT(11),	        -- Auditoria
    Aud_Usuario         	INT(11),            -- Auditoria
    Aud_FechaActual     	DATETIME,           -- Auditoria
    Aud_DireccionIP     	VARCHAR(15),        -- Auditoria
    Aud_ProgramaID      	VARCHAR(50),        -- Auditoria
    Aud_Sucursal        	INT(11),            -- Auditoria
    Aud_NumTransaccion		BIGINT(20)          -- Auditoria
)
TerminaStore:BEGIN

 -- Variables
	DECLARE Var_Periodo 		VARCHAR(8);     -- Periodo
	DECLARE Var_ClaveEntidad 	VARCHAR(10);    -- Clave de entidad
	DECLARE Var_NumCliente		INT;            -- Numero de cliente
	DECLARE Var_TipoInsti		INT;            -- Tipo de Institucion
	DECLARE Var_EsEspecial		CHAR(1);        -- Es reporte especial
	DECLARE Var_NumCliReg		VARCHAR(3);     -- Numero Cliente
	DECLARE Var_NombreReporte	VARCHAR(29);    -- Nombre del reporte
	DECLARE Var_llamada 		VARCHAR(400);   -- Llamada

	-- Constantes
	DECLARE NumReporte			VARCHAR(7);     -- Numero de reporte
	DECLARE Entero_Cero			INT;            -- Entero Cero
	DECLARE Cadena_Vacia 		VARCHAR(2);     -- Cadena vacia
	DECLARE Resp_SI 			CHAR(1);        -- Respuesta si
	DECLARE Resp_NO 			CHAR(1);        -- Respuesta no
   	DECLARE Con_CliProcEspe     VARCHAR(20);    -- Cliente proceso especifico
   	DECLARE Con_TipoRegula      VARCHAR(20);    -- Tipo de Regulatorio



	SET NumReporte			:= 'A2111';				-- Clave del reporte
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
		'(',Par_Anio,',',Par_Mes,',',Par_NumRep,',',Par_EmpresaID,',',Aud_Usuario,',',"'",Aud_FechaActual,"'",',',"'",Aud_DireccionIP,"'",',',"'",Aud_ProgramaID,"'",',',Aud_Sucursal,',',Aud_NumTransaccion,');');


	SET @Sentencia    = (Var_Llamada);
	PREPARE EjecutaProc FROM @Sentencia;
	EXECUTE  EjecutaProc;
	DEALLOCATE PREPARE EjecutaProc;


END TerminaStore$$