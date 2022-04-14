-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CHEQUESEMITIDOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CHEQUESEMITIDOSCON`;
DELIMITER $$


CREATE PROCEDURE `CHEQUESEMITIDOSCON`(
# ==================================================================
# -------------- SP PARA CONSULTAR CHEQUES EMITIDOS ----------------
# ==================================================================
	Par_InstitucionID		INT(11),
	Par_CuentaInstitucion	VARCHAR(20),
	Par_NumeroCheque		INT(10),
    Par_TipoChequera		CHAR(2),	-- Tipo Chequera P- PROFORMA, E-ESTANDAR
	Par_NumCon				TINYINT UNSIGNED,

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
	)
TerminaStore:BEGIN

	--  Declaracion de Constantes
	DECLARE EstatusEmitido		CHAR(1);
	DECLARE EstatusCancelado	CHAR(1);
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Entero_Cero			INT(11);
	DECLARE TipoMoral			CHAR(1);
	DECLARE ConPrincipal		INT(11);
	DECLARE Con_NumTrasaccion	INT(11);
	DECLARE ConSoloEmitidos		INT(11);
	DECLARE Con_ChequeGastAnt	INT(11);
	DECLARE Con_CheDispSinReq	INT(11);
	DECLARE Con_CheDispConReq	INT(11);
	DECLARE Con_ChequeConcilia	INT(11);


	-- Asignacion de constantes
	SET EstatusEmitido			:= 'E'; -- Estatus Emitido
	SET EstatusCancelado		:= 'C'; -- Estatus Cancelado
	SET Cadena_Vacia			:= '';	-- Cadena Vacia
	SET Entero_Cero				:= 0;	-- Entero Cero
	SET TipoMoral				:= 'M';	-- Constante M para tipo de persona Moral
	SET ConPrincipal			:= 1; 	-- Consulta principal
	SET Con_NumTrasaccion		:= 3;	-- Para saber si una dispersion registro por lo menos un cheque y su estatus sea diferente de C.
	SET ConSoloEmitidos			:= 4;	-- Consulta solo los Cheques Emitidos
	SET Con_ChequeGastAnt		:= 5;	-- Consulta cheques gastos y anticipos
	SET Con_CheDispSinReq		:= 6;	-- Consulta cheques dispersiones sin requisiciones
	SET Con_CheDispConReq		:= 7;	-- Consulta cheques dispersiones con requisiciones
	SET Con_ChequeConcilia		:= 8;	-- Consulta estatus de movimiento de tesoreria relacionado con el cheque


	IF(Par_NumCon = ConPrincipal)THEN
		SELECT 	C.InstitucionID,			C.CuentaInstitucion,			C.NumeroCheque,					C.FechaEmision,						C.Monto,
				C.SucursalID,				C.CajaID,			 			C.UsuarioID,					C.Concepto,							C.Beneficiario,
				C.Estatus,					S.NombreSucurs,					CH.MotivoID AS MotivoCancela,	CAT.Descripcion	AS MotivoCanDes,	CH.Comentario,
				C.Concepto,					C.Beneficiario,					R.NumReqGasID,					DM.ProveedorID,						R.NoFactura AS Referencia,
				DM.Estatus AS EstatusDisp,	IFNULL(DM.AnticipoFact,
											Cadena_Vacia) AS AnticipoFact,	IFNULL(DM.FacturaProvID,
																			Entero_Cero) AS FacturaProvID,
				CASE P.TipoPersona WHEN TipoMoral THEN P.RazonSocial ELSE
					CONCAT(P.SoloNombres," ", P.SoloApellidos) END  AS NombreProv
			FROM 	CHEQUESEMITIDOS AS C
			INNER JOIN SUCURSALES AS S ON C.SucursalID=S.SucursalID
			LEFT JOIN CANCELACHEQUES AS CH ON C.NumeroCheque = CH.NumCheque
			LEFT JOIN CATMOTCANCELCHEQUE AS CAT ON CH.MotivoID = CAT.MotivoID
			LEFT JOIN HISDISPERSIONMOV DM ON C.Referencia = DM.Referencia AND C.NumeroCheque=DM.CuentaDestino
			LEFT JOIN REQGASTOSUCURMOV R ON DM.DetReqGasID = R.DetReqGasID
			LEFT JOIN PROVEEDORES P ON R.ProveedorID = P.ProveedorID
			WHERE 	C.InstitucionID		= Par_InstitucionID
			AND 	C.CuentaInstitucion	= Par_CuentaInstitucion
            AND 	C.TipoChequera		= Par_TipoChequera
			AND 	C.NumeroCheque		= Par_NumeroCheque;

	END IF;

	IF(Par_NumCon = ConSoloEmitidos)THEN
		SELECT 	InstitucionID,	CuentaInstitucion,	NumeroCheque,	FechaEmision,	Monto,
				SucursalID,		CajaID,			 	UsuarioID,		Concepto,		Beneficiario,
				Estatus,		EmitidoEn
			FROM 	CHEQUESEMITIDOS
			WHERE 	Estatus 			= EstatusEmitido
			AND 	InstitucionID		= Par_InstitucionID
			AND 	CuentaInstitucion	= Par_CuentaInstitucion
			AND 	NumeroCheque		= Par_NumeroCheque;
	END IF;

	IF(Par_NumCon = Con_NumTrasaccion)THEN
		SELECT 		ce.Estatus,pc.PolizaID
			FROM 	CHEQUESEMITIDOS ce,
					POLIZACONTABLE pc
			WHERE	ce.NumTransaccion	= Par_NumeroCheque
			AND 	ce.ESTATUS 			!= EstatusCancelado
			AND 	pc.NumTransaccion	= Par_NumeroCheque
			LIMIT 1;

	END IF;

	IF(Par_NumCon = Con_ChequeGastAnt)THEN

		SELECT 	C.FechaEmision,		C.Monto,	C.SucursalID,	S.NombreSucurs,		C.Concepto,
				C.Beneficiario,		C.Estatus
			FROM 	CHEQUESEMITIDOS C
					INNER JOIN SUCURSALES S ON C.SucursalID=S.SucursalID
			WHERE 	C.CajaID 			!= Entero_Cero
			AND 	C.Estatus 			= EstatusEmitido
			AND 	C.InstitucionID		= Par_InstitucionID
			AND 	C.CuentaInstitucion = Par_CuentaInstitucion
            AND 	C.TipoChequera		= Par_TipoChequera
			AND 	C.NumeroCheque 		= Par_NumeroCheque;
	END IF;

	IF(Par_NumCon = Con_CheDispSinReq)THEN
	SELECT
		CH.FechaEmision,		CH.Monto,	CH.SucursalID,				SUC.NombreSucurs,		CH.Concepto,
		CH.Beneficiario,		CH.Estatus,	MOV.Estatus AS EstatusDisp,	MOV.CuentaDestino,		CH.Referencia,
		MOV.Referencia
		FROM CHEQUESEMITIDOS AS CH
			INNER JOIN DISPERSIONMOV AS MOV ON CH.NumeroCheque = MOV.CuentaDestino
			INNER JOIN SUCURSALES AS SUC ON CH.SucursalID=SUC.SucursalID
			WHERE
			CH.InstitucionID				= Par_InstitucionID
			AND		CH.CuentaInstitucion	= Par_CuentaInstitucion
			AND		CH.TipoChequera			= Par_TipoChequera
			AND		MOV.DetReqGasID 		= Entero_Cero
			AND		CH.NumeroCheque			= Par_NumeroCheque;
	END IF;


	IF(Par_NumCon = Con_CheDispConReq)THEN

		SELECT 	C.FechaEmision,		C.Monto,			C.SucursalID,		S.NombreSucurs, 	C.Concepto,
				C.Beneficiario,		R.NumReqGasID,		DM.ProveedorID,		R.NoFactura AS Referencia,
				CASE P.TipoPersona WHEN TipoMoral THEN P.RazonSocial ELSE
					CONCAT(P.PrimerNombre ," ", P.SegundoNombre," ", P.ApellidoPaterno," ", P.ApellidoMaterno) END  AS NombreProv,
				C.Estatus,			DM.Estatus AS EstatusDisp,	IFNULL(DM.AnticipoFact,Cadena_Vacia) AS AnticipoFact ,
				IFNULL(DM.FacturaProvID,Entero_Cero) AS FacturaProvID
			FROM CHEQUESEMITIDOS C
					INNER JOIN SUCURSALES S ON C.SucursalID=S.SucursalID
					INNER JOIN DISPERSIONMOV DM ON C.Referencia = DM.Referencia AND C.NumeroCheque=DM.CuentaDestino
					INNER JOIN REQGASTOSUCURMOV R ON DM.DetReqGasID = R.DetReqGasID
					INNER JOIN PROVEEDORES P ON R.ProveedorID = P.ProveedorID
			WHERE	C.CajaID 			= Entero_Cero
			AND 	C.Estatus 			= EstatusEmitido
			AND 	DM.DetReqGasID 		!= Entero_Cero
			AND 	C.InstitucionID 	= Par_InstitucionID
			AND 	C.CuentaInstitucion	= Par_CuentaInstitucion
            AND 	C.TipoChequera		= Par_TipoChequera
			AND 	C.NumeroCheque 		= Par_NumeroCheque;

	END IF;

	IF(Par_NumCon = Con_ChequeConcilia)THEN

		SELECT 	TM.Status as EstatusMov
			FROM TESORERIAMOVS TM
					INNER JOIN CHEQUESEMITIDOS C ON TM.MontoMov=C.Monto AND TM.NumTransaccion = C.NumTransaccion
			WHERE   C.InstitucionID 	= Par_InstitucionID
			AND 	C.CuentaInstitucion = Par_CuentaInstitucion
            AND 	C.TipoChequera		= Par_TipoChequera
			AND 	C.NumeroCheque 		= Par_NumeroCheque;


	END IF;

END TerminaStore$$