-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PSLPARAMBROKERCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PSLPARAMBROKERCON`;DELIMITER $$

CREATE PROCEDURE `PSLPARAMBROKERCON`(
	-- Stored procedure para consultar los parametros del broker
	Par_LlaveParametro 		VARCHAR(50),						-- Llave del parametro
	Par_ValorParametro 		VARCHAR(200),						-- Valor del parametro

	Par_NumCon				TINYINT UNSIGNED,					-- Opcion de consulta

	Aud_EmpresaID			INT(11),							-- Parametro de auditoria
	Aud_Usuario				INT(11),							-- Parametro de auditoria
	Aud_FechaActual			DATETIME,							-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),    					-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),						-- Parametro de auditoria
	Aud_Sucursal			INT(11),							-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT								-- Parametro de auditoria
)
TerminaStore : BEGIN

	DECLARE ConURLHubServicios		TINYINT;
	DECLARE ConUsuHubServicios		TINYINT;
	DECLARE ConPasHubServicios		TINYINT;
	DECLARE ConHoraActProducts		TINYINT;
	DECLARE ConActDiariaProdts		TINYINT;
	DECLARE ConUltActProductos		TINYINT;
	DECLARE ContActProductos		TINYINT;
	DECLARE Var_LlaveURLHubServ		VARCHAR(30);
	DECLARE Var_LlaveUsuHubServ		VARCHAR(30);
	DECLARE Var_LlavePassHubServ	VARCHAR(30);
	DECLARE Var_LlaveHoraActProd	VARCHAR(30);
	DECLARE Var_LlaveActDiaProd		VARCHAR(30);
	DECLARE Var_LlaveUltActProd		VARCHAR(30);
	DECLARE Var_LlaveActProd		VARCHAR(30);

    SET ConURLHubServicios			:= 1;
    SET ConUsuHubServicios			:= 2;
    SET ConPasHubServicios			:= 3;
    SET ConHoraActProducts			:= 4;
    SET ConActDiariaProdts			:= 5;
    SET ConUltActProductos			:= 6;
    SET ContActProductos			:= 7;
	SET Var_LlaveURLHubServ			:= "URLHubServicios";
	SET Var_LlaveUsuHubServ			:= "UsuarioHubServicios";
	SET Var_LlavePassHubServ		:= "PasswordHubServicios";
	SET Var_LlaveHoraActProd		:= "HoraActulizacioProductos";
	SET Var_LlaveActDiaProd			:= "ActualizacionDiariaProductos";
	SET Var_LlaveUltActProd			:= "FechaUltimaActualizacion";
	SET Var_LlaveActProd			:= "ActualizandoProductos";

	IF (Par_NumCon = ConURLHubServicios) THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PSLPARAMBROKER
            WHERE	LlaveParametro	= Var_LlaveURLHubServ;
	END IF;

	IF (Par_NumCon = ConUsuHubServicios) THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PSLPARAMBROKER
            WHERE	LlaveParametro	= Var_LlaveUsuHubServ;
	END IF;

	IF (Par_NumCon = ConPasHubServicios) THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PSLPARAMBROKER
            WHERE	LlaveParametro	= Var_LlavePassHubServ;
	END IF;


	IF (Par_NumCon = ConHoraActProducts) THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PSLPARAMBROKER
            WHERE	LlaveParametro	= Var_LlaveHoraActProd;
	END IF;

	IF (Par_NumCon = ConActDiariaProdts) THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PSLPARAMBROKER
            WHERE	LlaveParametro	= Var_LlaveActDiaProd;
	END IF;

	IF (Par_NumCon = ConUltActProductos) THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PSLPARAMBROKER
            WHERE	LlaveParametro	= Var_LlaveUltActProd;
	END IF;

	IF (Par_NumCon = ContActProductos) THEN
		SELECT LlaveParametro,	ValorParametro
			FROM PSLPARAMBROKER
            WHERE	LlaveParametro	= Var_LlaveActProd;
	END IF;
END TerminaStore$$