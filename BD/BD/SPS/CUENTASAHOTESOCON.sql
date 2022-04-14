-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASAHOTESOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASAHOTESOCON`;
DELIMITER $$

CREATE PROCEDURE `CUENTASAHOTESOCON`(
# =============================================================
# -------- SP PARA RELIZAR CONSULTAS DE CUENTAS BANCARIAS------
# =============================================================
	Par_InstitucionID		INT(11),
	Par_CuentaAhoID			BIGINT(12),
	Par_NumCtaInstit  		VARCHAR(20),
	Par_NumCon				TINYINT UNSIGNED,
	Par_FolioCheque			INT(11),
    Par_FolioChequeEstan	INT(11),
    Par_TipoChequera		CHAR(2),			-- Tipo Chequera A- ambas, P-Proforma, E-Estandar

	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_FolioUtilizado	CHAR(1);
    DECLARE Var_TipChequera		CHAR(2);
    DECLARE Var_Valor			CHAR(2);
    DECLARE Var_Descrip			VARCHAR(50);

	-- Declaracion de Constantes
	DECLARE	Con_Sucursal		INT(11);
	DECLARE Con_Resumen 		INT(11);
	DECLARE	Con_FolioInstit 	INT(11);
	DECLARE	Con_CuentaAhoID		INT(11);
	DECLARE	Con_CtaDes			INT(1);
	DECLARE	Con_Saldo	 		INT(11);
	DECLARE	Con_Estatus			INT(11);
	DECLARE Con_FolioUtilizar	INT(11);
	DECLARE Con_RutaCheque		INT(11);
	DECLARE Con_FolioEmitido 	INT(11);
    DECLARE Con_CtaNostroCheque	INT(11);
    DECLARE Con_Institucion		INT(11);	-- COnsultamos La isntitucion que pernece la cuenta de la tabla CUENTASAHOTESO para WS
    DECLARE Con_RutaChequeEstan	INT(11);
    DECLARE Con_SoloEmitidos	INT(11);
	DECLARE Entero_Cero 		INT(11);
	DECLARE Entero_Uno			INT(11);
	DECLARE Cadena_Vacia 		CHAR(1);
	DECLARE	Estatus_Activo		CHAR(1);
	DECLARE TipCheq_Proforma	CHAR(1);
    DECLARE TipCheq_Estandar	CHAR(1);
    DECLARE TipCheq_Ambas		CHAR(1);

	-- Asignacion de Constantes
	SET	Con_Sucursal			:= 3;	-- Consulta sucursal
	SET Con_Resumen      		:= 4;	-- Consulta Cta. Intitucion
	SET Con_FolioInstit			:= 5;	-- Consulta Folio Institucion
	SET Con_CuentaAhoID			:= 6;	-- consulta Cuentas Ahorro
	SET Con_CtaDes 				:= 9;	-- Consulta Cuentas
	SET Con_Saldo				:= 10;	-- consulta Saldos
	SET Con_Estatus				:= 11;	-- Consulta Estatus
	SET Con_FolioUtilizar		:= 12;
	SET Con_RutaCheque			:= 13; 	-- Consulta para conocer el nombre del archivo del cheque .prpt
	SET Con_FolioEmitido		:= 14; 	-- Consulta para saber si el folio ya fue utilizado --
    SET Con_CtaNostroCheque		:= 15;	-- Consulta para saber el tipo de chequera
    SET Con_RutaChequeEstan		:= 16;	-- Consulta para conocer el nombre del archivo del cheque estandar
    SET Con_SoloEmitidos		:= 17;	-- Consulta para cheques emitidos
    SET Con_Institucion			:= 18;	-- COnsultamos La isntitucion que pernece la cuenta de la tabla CUENTASAHOTESO para WS
	SET Entero_Cero				:= 0; 	-- Constante Entero Cero --
	SET Entero_Uno				:= 1; 	-- Constante entero uno --
	SET Cadena_Vacia			:= '';
	SET Estatus_Activo   		:= 'A';	-- Estatus Activo de la No. de Cta. de la Institucio
	SET Var_FolioUtilizado 		:='';
	SET TipCheq_Proforma		:= 'P';	-- Tipo chequera proforma
    SET TipCheq_Estandar		:= 'E';	-- Tipo chequera estandar
    SET TipCheq_Ambas			:= 'A';	-- Tipo Chequera Ambas



	IF(Par_NumCon = Con_Sucursal) THEN
		SELECT 		SucursalInstit AS NombreSucurs
			FROM 	CUENTASAHOTESO
			WHERE 	CuentaAhoID 	= Par_CuentaAhoID
			AND 	InstitucionID 	= Par_InstitucionID;
	END IF;

	IF(Par_NumCon = Con_Resumen) THEN
		SELECT 		CuentaAhoID,	InstitucionID,			SucursalInstit,	NumCtaInstit,	CueClave,
					Chequera,  		CuentaCompletaID,		CentroCostoID, 	Saldo,			Principal,
					Estatus, 		IFNULL(FolioUtilizar,Entero_Cero)AS FolioUtilizar, IFNULL(RutaCheque,Cadena_Vacia) AS RutaCheque, SobregirarSaldo,
					IFNULL(TipoChequera,Cadena_Vacia) AS TipoChequera,   IFNULL(FolioUtilizarEstan,Entero_Cero)AS FolioUtilizarEstan,
                    IFNULL(RutaChequeEstan,Cadena_Vacia) AS RutaChequeEstan,
                    NumConvenio, DescConvenio, ProtecOrdenPago, AlgClaveRetiro, VigClaveRetiro
			FROM 	CUENTASAHOTESO
			WHERE 	InstitucionID	= Par_InstitucionID
			AND 	NumCtaInstit 	= Par_NumCtaInstit;
	END IF;

	IF(Par_NumCon = Con_FolioInstit ) THEN
		SELECT 		Folio AS CueClave
			FROM  	INSTITUCIONES
			WHERE 	InstitucionID = Par_InstitucionID;
	END IF;

	IF(Par_NumCon = Con_CuentaAhoID)THEN
		SELECT 		cht.NumCtaInstit, ch.Etiqueta, cht.CuentaAhoID, cht.Saldo, ch.MonedaID,
					cht.SobregirarSaldo, cht.ProtecOrdenPago
			FROM 	CUENTASAHOTESO cht
					JOIN CUENTASAHO ch ON cht.CuentaAhoID=ch.CuentaAhoID
			WHERE 	cht.InstitucionID	= Par_InstitucionID
			AND 	cht.NumCtaInstit 	= Par_CuentaAhoID
			AND 	cht.Estatus 		= Estatus_Activo;
	END IF;


	IF(Par_NumCon = Con_CtaDes ) THEN
		SELECT 		cht.NumCtaInstit,	ch.Etiqueta,	cht.CuentaAhoID,	cht.Saldo,	ch.MonedaID,
					cht.SobregirarSaldo, cht.ProtecOrdenPago
			FROM 	CUENTASAHOTESO cht
					JOIN CUENTASAHO ch ON cht.CuentaAhoID=ch.CuentaAhoID
			WHERE 	cht.InstitucionID	= Par_InstitucionID
			AND 	cht.NumCtaInstit 	= Par_NumCtaInstit
			AND 	cht.Estatus 		= Estatus_Activo;
	END IF;

	-- Para consultar el saldo de la Cuenta de tesoreria
	IF(Par_NumCon = Con_Saldo) THEN
		SELECT 		FORMAT(Saldo,2) AS Saldo
			FROM  	CUENTASAHOTESO
			WHERE	InstitucionID	= Par_InstitucionID
			AND 	NumCtaInstit	= Par_NumCtaInstit;
	END IF;

	IF(Par_NumCon = Con_Estatus) THEN
		SELECT 	 	Estatus
			FROM 	CUENTASAHOTESO
			WHERE 	InstitucionID 	= Par_InstitucionID
			AND 	NumCtaInstit 	= Par_NumCtaInstit ;
	END IF;

	IF(Par_NumCon = Con_FolioUtilizar) THEN
		SELECT 		FolioUtilizar,	CuentaAhoID,	CueClave,	RutaCheque
			FROM 	CUENTASAHOTESO
			WHERE 	InstitucionID	= Par_InstitucionID
			AND 	NumCtaInstit	= Par_NumCtaInstit;
	END IF ;

	IF(Par_NumCon = Con_RutaCheque) THEN
		SELECT 		RutaCheque,CuentaAhoID
			FROM 	CUENTASAHOTESO
			WHERE 	InstitucionID	= Par_InstitucionID
			AND 	NumCtaInstit	= Par_NumCtaInstit;
	END IF;

	IF(Par_NumCon = Con_FolioEmitido)THEN
		SELECT 		NumeroCheque
			FROM 	CHEQUESEMITIDOS
			WHERE 	InstitucionID 		= Par_InstitucionID
			AND 	cuentainstitucion	= Par_NumCtaInstit
			AND 	NumeroCheque 		= Par_FolioCheque
			AND 	TipoChequera 		= Par_TipoChequera;
	END IF;

	IF (Par_NumCon = Con_CtaNostroCheque)THEN

		DROP TEMPORARY TABLE IF EXISTS TIPOSCHEQUERA;
		CREATE TEMPORARY TABLE TIPOSCHEQUERA(
			TipoChequera		CHAR(2),
			Valor				CHAR(2),
			Descrip				VARCHAR(20)
		);

        INSERT INTO TIPOSCHEQUERA
			VALUES('A','P','PROFORMA');
		INSERT INTO TIPOSCHEQUERA
			VALUES('A','E','CHEQUERA');
		INSERT INTO TIPOSCHEQUERA
			VALUES('P','P','PROFORMA');
        INSERT INTO TIPOSCHEQUERA
			VALUES('E','E','CHEQUERA');


		SELECT TipoChequera INTO Var_TipChequera
			FROM 	CUENTASAHOTESO
			WHERE 	InstitucionID	= Par_InstitucionID
			AND 	NumCtaInstit	= Par_NumCtaInstit;

		SELECT Valor AS TipoChequera, Descrip AS DescripTipoChe
				FROM TIPOSCHEQUERA
                WHERE TipoChequera = Var_TipChequera;


	END IF;

	IF(Par_NumCon = Con_RutaChequeEstan) THEN
		SELECT 		RutaChequeEstan,CuentaAhoID
			FROM 	CUENTASAHOTESO
			WHERE 	InstitucionID	= Par_InstitucionID
			AND 	NumCtaInstit	= Par_NumCtaInstit;
	END IF;

	IF(Par_NumCon = Con_SoloEmitidos)THEN
		SELECT 	InstitucionID,	CuentaInstitucion,	NumeroCheque,	FechaEmision,	Monto,
				SucursalID,		CajaID,			 	UsuarioID,		Concepto,		Beneficiario,
				Estatus,		EmitidoEn
			FROM 	CHEQUESEMITIDOS
			WHERE 	Estatus 			= TipCheq_Estandar
			AND 	InstitucionID		= Par_InstitucionID
			AND 	CuentaInstitucion	= Par_NumCtaInstit
			AND 	NumeroCheque		= Par_FolioCheque
            AND		TipoChequera		= Par_TipoChequera;
	END IF;

	-- COnsultamos La isntitucion que pernece la cuenta de la tabla CUENTASAHOTESO para WS
	IF(Par_NumCon = Con_Institucion) THEN
		SELECT	InstitucionID,		CuentaAhoID,		NumCtaInstit
			FROM CUENTASAHOTESO
			WHERE NumCtaInstit = Par_NumCtaInstit
			LIMIT 1;
	END IF;


END TerminaStore$$