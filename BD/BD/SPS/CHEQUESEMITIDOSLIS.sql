-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CHEQUESEMITIDOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CHEQUESEMITIDOSLIS`;DELIMITER $$

CREATE PROCEDURE `CHEQUESEMITIDOSLIS`(
# ==================================================================
# -------------- SP PARA LISTAR CHEQUES EMITIDOS ----------------
# ==================================================================
	Par_InstitucionID		INT(11),			-- Numero de institucion
	Par_CuentaInstitucion 	BIGINT(12),			-- Cuenta de institucion
	Par_NumeroCheque  		INT(10),			-- Numero de Cheque
	Par_NomBeneficiario		VARCHAR(200),		-- Nombre del beneficiario
    Par_NumLis          	TINYINT UNSIGNED,	-- Numero de lista

    Par_SucursalID			INT(11),			-- Numero de la Sucursal
    Par_FechaInicio			DATE,				-- Fecha de inicio de la emision del cheque
    Par_FechaFinal			DATE,				-- Fecha de fin de la emision de cheque
    Par_TipoChequera		CHAR(2),			-- Tipo Chequera P- PROFORMA, E-ESTANDAR

    Par_EmpresaID      	 	INT(11),
    Aud_Usuario         	INT(11),
    Aud_FechaActual     	DATETIME,
    Aud_DireccionIP     	VARCHAR(15),
    Aud_ProgramaID      	VARCHAR(50),
    Aud_Sucursal        	INT(11),
    Aud_NumTransaccion  	BIGINT(20)

)
TerminaStore:BEGIN

	-- Declaracion de variables
	DECLARE Var_Sentencia				VARCHAR(60000);		-- Variable para la consulta

	-- Declaracion de contantes

	DECLARE Estatus_Emitidos			CHAR(1);
	DECLARE EstatusCancelado			CHAR(1);
    DECLARE Si							CHAR(1);
	DECLARE EnteroCero					INT(11);
	DECLARE Cadena_Vacia				CHAR(1);
    DECLARE Fecha_Vacia					DATE;
	DECLARE Lis_ChequesEmitidos			INT(11);
	DECLARE ChequesEmitidos				INT(11);
	DECLARE Lis_TodosEmitidos			INT(11);
	DECLARE List_ChequesEmitidosTeso	INT(11);
	DECLARE ChequesGastosAnticipos		INT(11);
    DECLARE ChequesDispSinReq			INT(11);
    DECLARE ChequesDispConReq			INT(11);


	-- Asingacion de Contantes
	SET Estatus_Emitidos				:= 'E';		-- Estatus Emitido
    SET EstatusCancelado				:= 'C';		-- Estatus Cancelado
    SET Si								:= 'S';		-- Constante S.
	SET EnteroCero						:= 0;		-- Entero cero
	SET Cadena_Vacia					:= '';		-- Cadena vacia
	SET Fecha_Vacia						:= '1900-01-01';	-- Fecha Vacia
	SET Lis_ChequesEmitidos				:= 2;		-- Lista de cheques emitidos
	SET ChequesEmitidos					:= 3;		-- Lista de cheques emitidos
	SET Lis_TodosEmitidos				:= 4;		-- Lista de Todos lod Cheques Emitidos.
    SET List_ChequesEmitidosTeso		:= 5;		-- Lista de cheques emitidos por tesoseria
    SET ChequesGastosAnticipos			:= 6;		-- Lista de cheques de gastos y anticipos
    SET ChequesDispSinReq				:= 7;		-- Lista de cheques de dispersiones sin requesiciones
    SET ChequesDispConReq				:= 8;		-- Lista de cheques de dispersiones con requesiciones


	IF(Par_NumLis = Lis_ChequesEmitidos) THEN
		SELECT 		ClienteID, Beneficiario, NumeroCheque, Estatus, CONCAT(NumeroCheque,'-',CuentaInstitucion,'-',InstitucionID) AS Institucion
			FROM 	CHEQUESEMITIDOS
			WHERE 	Beneficiario LIKE CONCAT("%",Par_NomBeneficiario,"%")
			AND   	Estatus 			= Estatus_Emitidos
			AND 	InstitucionID 		= Par_InstitucionID
			AND 	CuentaInstitucion	= Par_CuentaInstitucion;
	END IF;

	-- lista normal --
	IF(Par_NumLis = ChequesEmitidos)THEN
		SELECT 		NumeroCheque, ClienteID, Beneficiario, FORMAT(Monto,2) AS Monto,FechaEmision
			FROM 	CHEQUESEMITIDOS
			WHERE 	Estatus 			= Estatus_Emitidos
			AND 	InstitucionID 		= Par_InstitucionID
			AND 	CuentaInstitucion	= Par_CuentaInstitucion
            AND 	TipoChequera		= Par_TipoChequera
			AND 	Beneficiario LIKE CONCAT("%",Par_NomBeneficiario,"%")
			LIMIT 0,15;
	END IF;

	IF(Par_NumLis = Lis_TodosEmitidos)THEN
		SELECT 		ClienteID, Beneficiario, NumeroCheque, Estatus
			FROM 	CHEQUESEMITIDOS
			WHERE 	InstitucionID 		= Par_InstitucionID
			AND 	CuentaInstitucion 	= Par_CuentaInstitucion
			AND 	Beneficiario LIKE CONCAT("%",Par_NomBeneficiario,"%")
			LIMIT 0,15;
	END IF;

	-- Lista para los cheques emitidos en tesoreria
	IF(Par_NumLis = List_ChequesEmitidosTeso) THEN
		SET Var_Sentencia	:=CONCAT('SELECT NumeroCheque, ClienteID, Beneficiario, format(Monto,2) as Monto, FechaEmision
			FROM CHEQUESEMITIDOS
            WHERE FechaEmision BETWEEN \'',Par_FechaInicio,'\' AND \'',Par_FechaFinal,'\'');
            -- Por institucion
            IF(IFNULL(Par_InstitucionID, EnteroCero) != EnteroCero) THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia,' AND InstitucionID=',Par_InstitucionID);
			END IF;

			-- Por cuenta
			IF(IFNULL(Par_CuentaInstitucion, EnteroCero) != EnteroCero) THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia,' AND CuentaInstitucion=',Par_CuentaInstitucion);
			END IF;

			-- por sucursal
			IF(IFNULL(Par_SucursalID, EnteroCero) != EnteroCero) THEN
				SET Var_Sentencia := CONCAT(Var_sentencia,' AND SucursalID =',Par_SucursalID);
			END IF;

			-- por Beneficiario
			IF(IFNULL(Par_NomBeneficiario, Cadena_Vacia) != Cadena_Vacia) THEN
				SET Var_Sentencia := CONCAT(Var_sentencia,' AND Beneficiario LIKE CONCAT(','"%","',Par_NomBeneficiario,'","%"',')');
			END IF;

			-- por Tipo de Chequera
			IF(IFNULL(Par_TipoChequera, Cadena_Vacia) != Cadena_Vacia) THEN
				SET Var_Sentencia := CONCAT(Var_sentencia,' AND TipoChequera ="',Par_TipoChequera,'"');
			END IF;

	    	SET Var_Sentencia	:=CONCAT(Var_Sentencia,' LIMIT 0,15');
	    	SET @Sentencia	= (Var_Sentencia);

		   PREPARE CHEQUESEMITIDOSLIST FROM @Sentencia;
		   EXECUTE CHEQUESEMITIDOSLIST;
		   DEALLOCATE PREPARE CHEQUESEMITIDOSLIST;
	END IF;

	-- lista de cheques gastos y anticipos --
	IF(Par_NumLis = ChequesGastosAnticipos) THEN
		SELECT NumeroCheque, Beneficiario, FORMAT(Monto,2) AS Monto,FechaEmision
			FROM	CHEQUESEMITIDOS
			WHERE	Estatus 			= Estatus_Emitidos
			AND 	CajaID 				!= EnteroCero
			AND 	InstitucionID		= Par_InstitucionID
			AND 	CuentaInstitucion	= Par_CuentaInstitucion
            AND 	TipoChequera		= Par_TipoChequera
			AND 	Beneficiario LIKE CONCAT("%",Par_NomBeneficiario,"%")
			LIMIT 0,15;
	END IF;

	-- lista de cheques de dispersiones sin requisiciones --
	IF(Par_NumLis = ChequesDispSinReq) THEN

		SELECT C.NumeroCheque, C.Beneficiario, FORMAT(C.Monto,2) AS Monto,C.FechaEmision
			FROM CHEQUESEMITIDOS C
				INNER JOIN DISPERSIONMOV DM ON C.Referencia = DM.Referencia AND C.NumeroCheque=DM.CuentaDestino
			WHERE	C.Estatus 			= Estatus_Emitidos
			AND 	C.CajaID 			= EnteroCero
			AND 	DM.DetReqGasID 		= EnteroCero
			AND 	C.InstitucionID 	= Par_InstitucionID
			AND 	C.CuentaInstitucion	= Par_CuentaInstitucion
            AND		C.TipoChequera		= Par_TipoChequera
			AND 	C.Beneficiario LIKE CONCAT("%",Par_NomBeneficiario,"%")
			LIMIT 0,15;
	END IF;


	-- lista de cheques de dispersiones con requisiciones --
	IF(Par_NumLis = ChequesDispConReq) THEN
		SELECT C.NumeroCheque, C.Beneficiario, FORMAT(C.Monto,2) AS Monto,C.FechaEmision
			FROM CHEQUESEMITIDOS C
				INNER JOIN DISPERSIONMOV DM ON C.Referencia = DM.Referencia AND C.NumeroCheque=DM.CuentaDestino
			WHERE	C.Estatus 			= Estatus_Emitidos
			AND 	C.CajaID 			= EnteroCero
			AND 	DM.DetReqGasID 		!= EnteroCero
			AND 	DM.AnticipoFact 	!= Si
			AND 	DM.FacturaProvID 	!= EnteroCero
			AND 	C.InstitucionID 	= Par_InstitucionID
			AND 	C.CuentaInstitucion	= Par_CuentaInstitucion
            AND		C.TipoChequera		= Par_TipoChequera
			AND 	C.Beneficiario LIKE CONCAT("%",Par_NomBeneficiario,"%")
			LIMIT 0,15;

	END IF;

END TerminaStore$$