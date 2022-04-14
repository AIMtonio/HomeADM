-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REIMPRESIONCHEQUESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `REIMPRESIONCHEQUESCON`;DELIMITER $$

CREATE PROCEDURE `REIMPRESIONCHEQUESCON`(
# ===============================================================
# -------- SP PARA RELIZAR CONSULTA DE REIMPRESION DE CHEQUES------
# ===============================================================
	Par_InstitucionID		INT(11),
	Par_CuentaInstitucion 	VARCHAR(50),
	Par_FechaEmision		DATE,
	Par_NumeroCheque		INT(10),
	Par_CajaID				INT(11),
    Par_TipoChequera		CHAR(2),
	Par_NumCon				TINYINT UNSIGNED,

    Par_EmpresaID      	 	INT(11),
    Aud_Usuario         	INT(11),
    Aud_FechaActual     	DATETIME,
    Aud_DireccionIP     	VARCHAR(15),
    Aud_ProgramaID      	VARCHAR(50),
    Aud_Sucursal        	INT(11),
    Aud_NumTransaccion  	BIGINT(20)
)
TerminaStore:BEGIN

	-- DeclaraciOn de constantes
	DECLARE Est_Emitido 		CHAR(1);
	DECLARE	Con_Emitidos 		INT(11);
	DECLARE Cadena_Vacia  		CHAR(1);
	DECLARE TipCheq_Proforma	CHAR(1);
    DECLARE TipCheq_Estandar	CHAR(1);

	-- Declaracion de variables
	DECLARE Var_NumTransaccion 	BIGINT(20);
	DECLARE Var_RutaCheque 		VARCHAR(100);
	DECLARE Var_PolizaH			INT(11);
	DECLARE Var_PolizaD			INT(11);
	DECLARE Var_Poliza			INT(11);

	-- Asignacion de constantes
	SET Est_Emitido				:= 'E';
	SET Con_Emitidos			:= 1;
	SET Cadena_Vacia			:= '';
	SET TipCheq_Proforma		:= 'P';			-- Tipo chequera proforma
    SET TipCheq_Estandar		:= 'E';			-- Tipo chequera estandar


	SELECT NumTransaccion
		INTO  Var_NumTransaccion
		FROM 	CHEQUESEMITIDOS
		WHERE 	InstitucionID 		= Par_InstitucionID
		AND 	CuentaInstitucion	= Par_CuentaInstitucion
        AND 	TipoChequera		= Par_TipoChequera
		AND 	NumeroCheque		= Par_NumeroCheque
		AND 	Estatus 			= Est_Emitido;


	IF (Par_TipoChequera = TipCheq_Proforma)THEN
    	SELECT RutaCheque
			INTO  Var_RutaCheque
			FROM 	CUENTASAHOTESO
			WHERE 	InstitucionID	= Par_InstitucionID
			AND 	NumCtaInstit	= Par_CuentaInstitucion;

	ELSEIF(Par_TipoChequera = TipCheq_Estandar)THEN
		SELECT RutaChequeEstan
			INTO  Var_RutaCheque
			FROM 	CUENTASAHOTESO
			WHERE 	InstitucionID	= Par_InstitucionID
			AND 	NumCtaInstit	= Par_CuentaInstitucion;
    END IF;

	SELECT PolizaID
		INTO  	Var_PolizaD
		FROM 	DETALLEPOLIZA
		WHERE 	NumTransaccion	= Var_NumTransaccion
		AND 	Fecha 			= Par_FechaEmision
		LIMIT 1;

	IF (IFNULL(Var_PolizaD,0) = 0) THEN
		SELECT PolizaID
			INTO  Var_PolizaH
			FROM `HIS-DETALLEPOL`
			WHERE NumTransaccion = Var_NumTransaccion
			AND Fecha = Par_FechaEmision
			LIMIT 1;
	END IF;


	IF(Var_PolizaD != '') THEN
		SET Var_Poliza := Var_PolizaD;
		ELSEIF(Var_PolizaH !='')THEN
		SET Var_Poliza :=Var_PolizaH;
	END IF;

	IF(Par_NumCon = Con_Emitidos)THEN
		SELECT che.NumeroCheque, LPAD(che.ClienteID,10,'0') AS ClienteID, che.Beneficiario, che.Monto, che.Concepto,
				che.Referencia,	substring(che.FechaActual,12,8) AS FechaActual, che.NumTransaccion,IFNULL(Var_RutaCheque,Cadena_Vacia) AS Var_RutaCheque,
				che.SucursalID,che.CajaID, che.FechaEmision, che.UsuarioID AS IDUsuario, Var_Poliza, usu.Clave AS UsuarioID
		 FROM CHEQUESEMITIDOS che,
				USUARIOS usu
			WHERE 	che.InstitucionID 		= Par_InstitucionID
			AND 	che.CuentaInstitucion 	= Par_CuentaInstitucion
            AND		che.TipoChequera		= Par_TipoChequera
            AND 	che.CajaID 				= Par_CajaID
			AND 	che.NumeroCheque 		= Par_NumeroCheque
			AND 	FechaEmision 			= Par_FechaEmision
			AND 	che.Estatus 			= Est_Emitido
			AND 	che.UsuarioID 			= usu.UsuarioID;
	END IF;

END TerminaStore$$