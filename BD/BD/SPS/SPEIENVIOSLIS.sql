

-- SPEIENVIOSLIS --

DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEIENVIOSLIS`;
-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE `SPEIENVIOSLIS`(
# ================================================================
# ------- STORE PARA LISTAR LOS ENVIOS SPEI ---------
# ================================================================
	Par_Folio					BIGINT(20),						-- Folio de Envio SPEI
	Par_ClienteID				BIGINT(20),						-- Numero de Cliente
	Par_FechaInicial			DATE,							-- Fecha Inicial
	Par_FechaFinal				DATE,							-- Fecha Final
	Par_Estatus					CHAR(1),						-- Estatus SPEI
	Par_PIDTarea				VARCHAR(50),					-- Numero referente a la Tarea

	Par_NumLis					TINYINT UNSIGNED,				-- Numero de Lista

	Par_EmpresaID				INT(11),						-- Parametros de Auditoria
	Aud_Usuario					INT(11),						-- Parametros de Auditoria
	Aud_FechaActual				DATETIME,						-- Parametros de Auditoria
	Aud_DireccionIP				VARCHAR(20),					-- Parametros de Auditoria
	Aud_ProgramaID				VARCHAR(50),					-- Parametros de Auditoria
	Aud_Sucursal				INT(11),						-- Parametros de Auditoria
	Aud_NumTransaccion			BIGINT(20)						-- Parametros de Auditoria
)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_FechaSis		DATE;							-- fecha de sistema

	-- Declaracion de constantes
	DECLARE Cadena_Vacia		CHAR(1);						-- Cadena vacia
	DECLARE Fecha_Vacia			DATE;							-- Fecha Vacia
	DECLARE Entero_Cero			INT(11);						-- Entero vacio
	DECLARE Estatus_Pen			CHAR(1);						-- Estatus pendiente
	DECLARE Lis_Principal		INT(11);						-- Lista principal
	DECLARE Lis_Estatus			INT(11);						-- Lista por estatus
	DECLARE Lis_AutTes			INT(11);						-- Lista SPEI para autorizar por Tesoreria
	DECLARE Lis_EstatusWS		INT(11);						-- Lista Estatus WS
	DECLARE Lis_PendEnviar		INT(11);						-- Consulta para obtener las ordenes de pago pendientes por enviar
	DECLARE Estatus_Aut			CHAR(1);						-- Estatus de autorizacion
	DECLARE tipoCuentaClabe		INT(11);						-- Tipo de cuenta clabe
	DECLARE tipoCuentaTarj		INT(11);						-- Tipo de cuenta tarjeta
	DECLARE tipoCuentaCel		INT(11);						-- Tipo cuenta celular
	DECLARE desTipoCuentaClabe	VARCHAR(20);					-- Descripcion cuenta clabe
	DECLARE desTipoCuentaTarj	VARCHAR(20);					-- Descripcion cuenta tarjeta
	DECLARE desTipoCuentaCel	VARCHAR(20);					-- Descripcion cuenta celular
	DECLARE estPendi			CHAR(1);						-- Estatus pendiente
	DECLARE estAut				CHAR(1);						-- Estatus autorizado
	DECLARE estCan				CHAR(1);						-- Estatus cancelado
	DECLARE estDet				CHAR(1);						-- Estatus detenido
	DECLARE estVer				CHAR(1);						-- Estatus verificado
	DECLARE estEnv				CHAR(1);						-- Estatus enviado
	DECLARE estDev				CHAR(1);						-- Estatus devuelto
	DECLARE desEstPendi			VARCHAR(30);					-- Descripcion de estatus pendiente
	DECLARE desEestAut			VARCHAR(30);					-- Descripcion de estatus autorizado
	DECLARE desEestCan			VARCHAR(30);					-- Descripcion de estatus cancelado
	DECLARE desEestDet			VARCHAR(30);					-- Descripcion de estatus detenido
	DECLARE desEestVer			VARCHAR(30);					-- Descripcion de estatus verificado
	DECLARE desEestEnv			VARCHAR(30);					-- Descripcion de estatus enviado
	DECLARE desEestDev			VARCHAR(30);					-- Descripcion de estatus devuelto

	DECLARE estEnvDev			INT(2);							-- referente a la tabla ESTADOSENVIOSPEI
	DECLARE estEnvSinAut		INT(2);							-- referente a la tabla ESTADOSENVIOSPEI
	DECLARE estEnvLiq			INT(2);							-- referente a la tabla ESTADOSENVIOSPEI
	DECLARE estEnvPenLiq		INT(2);							-- referente a la tabla ESTADOSENVIOSPEI
	DECLARE estEnvAut			INT(2);							-- referente a la tabla ESTADOSENVIOSPEI
	DECLARE estEnvRechBanx		INT(2);							-- referente a la tabla ESTADOSENVIOSPEI
	DECLARE estEnvCan			INT(2);							-- referente a la tabla ESTADOSENVIOSPEI
	DECLARE estEnvExpor			INT(2);							-- referente a la tabla ESTADOSENVIOSPEI
	DECLARE estEnvEnCola		INT(2);							-- referente a la tabla ESTADOSENVIOSPEI
	DECLARE estEnvOrdError		INT(2);							-- referente a la tabla ESTADOSENVIOSPEI
	DECLARE estEnvDet			INT(2);							-- referente a la tabla ESTADOSENVIOSPEI
	DECLARE estEnvTransBanx		INT(2);							-- referente a la tabla ESTADOSENVIOSPEI
	DECLARE estEnvPeEnv			INT(2);							-- referente a la tabla ESTADOSENVIOSPEI

	DECLARE desEstEnvDev		VARCHAR(30);					-- referente a la tabla ESTADOSENVIOSPEI
	DECLARE desEstEnvSinAut		VARCHAR(30);					-- referente a la tabla ESTADOSENVIOSPEI
	DECLARE desEstEnvLiq		VARCHAR(30);					-- referente a la tabla ESTADOSENVIOSPEI
	DECLARE desEstEnvPenLiq		VARCHAR(30);					-- referente a la tabla ESTADOSENVIOSPEI
	DECLARE desEstEnvAut		VARCHAR(30);					-- referente a la tabla ESTADOSENVIOSPEI
	DECLARE desEstEnvRechBanx	VARCHAR(30);					-- referente a la tabla ESTADOSENVIOSPEI
	DECLARE desEstEnvCan		VARCHAR(30);					-- referente a la tabla ESTADOSENVIOSPEI
	DECLARE desEstEnvExpor		VARCHAR(30);					-- referente a la tabla ESTADOSENVIOSPEI
	DECLARE desEstEnvEnCola		VARCHAR(30);					-- referente a la tabla ESTADOSENVIOSPEI
	DECLARE desEstEnvOrdError	VARCHAR(30);					-- referente a la tabla ESTADOSENVIOSPEI
	DECLARE desEstEnvDet		VARCHAR(30);					-- referente a la tabla ESTADOSENVIOSPEI
	DECLARE desEstEnvTransBanx	VARCHAR(30);					-- referente a la tabla ESTADOSENVIOSPEI
	DECLARE desEstEnvPeEnv		VARCHAR(30);					-- referente a la tabla ESTADOSENVIOSPEI
	DECLARE confirmadas			VARCHAR(30);					-- referente a la tabla ESTADOSENVIOSPEI
	DECLARE tipoBusqueda		CHAR(1);						-- Tipo de búsqueda que se hará Ventanilla o Movil

	SET tipoBusqueda			:=	Par_Estatus;				-- Se obtiene el tipo de búsqueda que se hará Ventanilla o Movil
	SET Cadena_Vacia			:= '';							-- Constante Cadena Vacia
	SET Fecha_Vacia				:= '1900-01-01';				-- Constante Fecha Vacia
	SET Entero_Cero				:= 0;							-- Constante Cero
	SET Estatus_Pen				:= 'P';							-- Estatus de Pendiente de autorizar por monto
	SET Estatus_Aut				:= 'A';							-- Estatus de Autorizado
	SET Lis_Principal			:= 1;							-- Lista Principal
	SET Lis_Estatus				:= 2;							-- Lista de Estatus
	SET Lis_AutTes				:= 3;							-- Lista SPEI para autorizar por Tesoreria
	SET Lis_EstatusWS			:= 4;							-- Lista Estatus WS
	SET Lis_PendEnviar			:= 5;							-- Consulta las ordenes de pago pendientes para enviar a STP
	SET tipoCuentaClabe			:= 40;							-- Tipo de Cuenta Clabe
	SET tipoCuentaTarj			:= 3;							-- Tipo de Cuenta Tarjeta Debito
	SET tipoCuentaCel			:= 10;							-- Tipo de cuenta Celular
	SET desTipoCuentaClabe		:= 'CUENTA CLABE';				-- Descripcion Cuenta Clabe
	SET desTipoCuentaTarj		:= 'TARJETA DEBITO';			-- Descripcion Tarjeta Debito
	SET desTipoCuentaCel		:= 'NUMERO CELULAR';			-- Descripcion Tipo Cienta Celular

	SET estPendi				:= 'P';							-- Estatus Pendiente
	SET estAut					:= 'A';							-- Estatus Autorizado
	SET estCan					:= 'C';							-- Estatus Cancelado
	SET estDet					:= 'T';							-- Estatus Detenido
	SET estVer					:= 'V';							-- Estatus Verificado
	SET estEnv					:= 'E';							-- Estatus Enviado
	SET estDev					:= 'D';							-- Estatus Devuelta
	SET desEstPendi				:= 'PENDIENTE';					-- Descripcion de Estatus Pendiente
	SET desEestAut				:= 'AUTORIZADA';				-- Descripcion de Estatus Autorizado
	SET desEestCan				:= 'CANCELADA';					-- Descripcion de Estatus Cancelado
	SET desEestDet				:= 'DETENIDA';					-- Descripcion de Estatus Detenido
	SET desEestVer				:= 'VERIFICADA';				-- Descripcion de Estatus Verificado
	SET desEestEnv				:= 'ENVIADA';					-- Descripcion de Estatus Enviado
	SET desEestDev				:= 'DEVUELTA';					-- Descripcion de Estatus Devuelta

	SET estEnvDev				:= 0;							-- referente a la tabla ESTADOSENVIOSPEI
	SET estEnvSinAut			:= 1;							-- referente a la tabla ESTADOSENVIOSPEI
	SET estEnvLiq				:= 2;							-- referente a la tabla ESTADOSENVIOSPEI
	SET estEnvPenLiq			:= 3;							-- referente a la tabla ESTADOSENVIOSPEI
	SET estEnvAut				:= 4;							-- referente a la tabla ESTADOSENVIOSPEI
	SET estEnvRechBanx			:= 5;							-- referente a la tabla ESTADOSENVIOSPEI
	SET estEnvCan				:= 6;							-- referente a la tabla ESTADOSENVIOSPEI
	SET estEnvExpor				:= 7;							-- referente a la tabla ESTADOSENVIOSPEI
	SET estEnvEnCola			:= 8;							-- referente a la tabla ESTADOSENVIOSPEI
	SET estEnvOrdError			:= 9;							-- referente a la tabla ESTADOSENVIOSPEI
	SET estEnvDet				:= 10;							-- referente a la tabla ESTADOSENVIOSPEI
	SET estEnvTransBanx			:= 11;							-- referente a la tabla ESTADOSENVIOSPEI
	SET estEnvPeEnv				:= 12;							-- referente a la tabla ESTADOSENVIOSPEI

	SET desEstEnvDev			:= 'ESTADO INVALIDO';			-- referente a la tabla ESTADOSENVIOSPEI
	SET desEstEnvSinAut			:= 'SIN AUTORIZAR';				-- referente a la tabla ESTADOSENVIOSPEI
	SET desEstEnvLiq			:= 'LIQUIDADA';					-- referente a la tabla ESTADOSENVIOSPEI
	SET desEstEnvPenLiq			:= 'PENDIENTE DE LIQUIDAR';		-- referente a la tabla ESTADOSENVIOSPEI
	SET desEstEnvAut			:= 'AUTORIZADA';				-- referente a la tabla ESTADOSENVIOSPEI
	SET desEstEnvRechBanx		:= 'RECHAZADA POR BANXICO';		-- referente a la tabla ESTADOSENVIOSPEI
	SET desEstEnvCan			:= 'CANCELADA';					-- referente a la tabla ESTADOSENVIOSPEI
	SET desEstEnvExpor			:= 'EXPORTADA';					-- referente a la tabla ESTADOSENVIOSPEI
	SET desEstEnvEnCola			:= 'EN COLA DE ENVIO';			-- referente a la tabla ESTADOSENVIOSPEI
	SET desEstEnvOrdError		:= 'ORDEN CON ERRORES';			-- referente a la tabla ESTADOSENVIOSPEI
	SET desEstEnvDet			:= 'DETENIDA';					-- referente a la tabla ESTADOSENVIOSPEI
	SET desEstEnvTransBanx		:= 'TRANSFERIDA A BANXICO';		-- referente a la tabla ESTADOSENVIOSPEI
	SET desEstEnvPeEnv			:= 'PRE-ENVIADA';				-- referente a la tabla ESTADOSENVIOSPEI
	SET confirmadas				:= 'CONFIRMADAS';

	SET Var_FechaSis			:= (SELECT	FechaSistema	FROM	PARAMETROSSIS);


	-- Consulta de la lista principal
	IF(Par_NumLis = Lis_Principal) THEN

		SELECT	SN.FolioSpeiID,			CA.ClienteID,		FNDECRYPTSAFI(SN.NombreOrd) AS NombreOrd,
				FORMAT(CASE WHEN FNDECRYPTSAFI(SN.TotalCargoCuenta) = '' THEN '0'
							ELSE FNDECRYPTSAFI(SN.TotalCargoCuenta) END ,2) AS TotalCargoCuenta,
				CASE	SN.TipoCuentaBen
					WHEN	tipoCuentaClabe	THEN	desTipoCuentaClabe
					WHEN	tipoCuentaTarj	THEN	desTipoCuentaTarj
					WHEN	tipoCuentaCel THEN	desTipoCuentaCel
					ELSE	Cadena_Vacia	END	AS	TipoCuentaBen,
				SN.InstiReceptoraID,	ISP.Descripcion,
				FNDECRYPTSAFI(SN.NombreBeneficiario) AS NombreBeneficiario,
				FNDECRYPTSAFI(SN.CuentaBeneficiario) AS CuentaBeneficiario,  SN.Comentario,
				SN.ClaveRastreo,	OS.NombreCompleto AS OrigenSpei
			FROM SPEIENVIOS SN
				INNER JOIN	CATSPEIORIGENES OS ON SN.OrigenOperacion = OS.OrigenSpeiID
				INNER JOIN	CUENTASAHO CA ON SN.CuentaAho = CA.CuentaAhoID
				INNER JOIN	INSTITUCIONESSPEI ISP ON SN.InstiReceptoraID = ISP.InstitucionID, PARAMETROSSIS PS
			WHERE	SN.Estatus = Estatus_Pen;

	END IF;

	-- Lista de estatus de SPEIENVIOS
	IF(Par_NumLis = Lis_Estatus) THEN
		(SELECT	FechaOperacion, FORMAT(SUM(CONVERT(FNDECRYPTSAFI(MontoTransferir), DECIMAL(16,2))),2) AS Monto,
				COUNT(Estatus) AS Cantidad,
				CASE Estatus
					WHEN	estPendi	THEN	desEstPendi
					WHEN	estAut		THEN	desEestAut
					WHEN	estCan		THEN	desEestCan
					WHEN	estDet		THEN	desEestDet
					WHEN	estVer		THEN	desEestVer
					WHEN	estDev		THEN	desEestDev
					WHEN	estEnv		THEN	desEestEnv
					ELSE	Cadena_Vacia END	AS	EstatusOpe
			FROM SPEIENVIOS
			WHERE	FechaOperacion = Var_FechaSis
			GROUP BY FechaOperacion,Estatus)
		UNION
		(SELECT	FechaOperacion, FORMAT(SUM(CONVERT(FNDECRYPTSAFI(MontoTransferir), DECIMAL(16,2))),2) AS Monto,
				COUNT(EstatusEnv) AS Cantidad,
				CASE	EstatusEnv
					WHEN	estEnvDev		THEN	desEstEnvDev
					WHEN	estEnvSinAut	THEN	desEstEnvSinAut
					WHEN	estEnvLiq		THEN	desEstEnvLiq
					WHEN	estEnvPenLiq	THEN	confirmadas
					WHEN	estEnvAut		THEN	desEstEnvAut
					WHEN	estEnvRechBanx	THEN	desEstEnvRechBanx
					WHEN	estEnvCan		THEN	desEstEnvCan
					WHEN	estEnvExpor		THEN	desEstEnvExpor
					WHEN	estEnvEnCola	THEN	confirmadas
					WHEN	estEnvOrdError	THEN	desEstEnvRechBanx
					WHEN	estEnvDet		THEN	desEstEnvDet
					WHEN	estEnvTransBanx	THEN	confirmadas
					WHEN	estEnvPeEnv		THEN	desEstEnvPeEnv
					ELSE	Cadena_Vacia	END		AS	EstatusOpe
			FROM SPEIENVIOS
			WHERE	Estatus = estEnv
			AND	FechaOperacion = Var_FechaSis
			GROUP BY FechaOperacion,EstatusOpe);
	END IF;

	-- Consulta para autorizar por Tesoreria
	IF(Par_NumLis = Lis_AutTes) THEN
		SELECT	FolioSpeiID,	FNDECRYPTSAFI(CuentaOrd) AS CuentaOrd,		FNDECRYPTSAFI(CuentaBeneficiario) AS CuentaBeneficiario,
				FNDECRYPTSAFI(NombreBeneficiario) AS NombreBeneficiario,	ClaveRastreo,
				FORMAT(CONVERT(FNDECRYPTSAFI(MontoTransferir), DECIMAL(16,2)),2) AS Monto
			FROM	SPEIENVIOS
			WHERE	Estatus	= Estatus_Aut AND OrigenOperacion = tipoBusqueda
			LIMIT 1000;
	END IF;

	-- Consulta de estatus del WS
	IF(Par_NumLis = Lis_EstatusWS) THEN
		SELECT	FNDECRYPTSAFI(SP.CuentaOrd) AS CuentaOrd,	SP.ClaveRastreo,	SP.FechaEnvio,
				FORMAT(CONVERT(FNDECRYPTSAFI(MontoTransferir), DECIMAL(16,2)),2) AS Monto,
				FNDECRYPTSAFI(SP.NombreBeneficiario) AS NombreBeneficiario,
				INS.Nombre,
				CASE	EstatusEnv
					WHEN	estEnvDev		THEN	desEstEnvPenLiq
					WHEN	estEnvSinAut	THEN	desEstEnvSinAut
					WHEN	estEnvLiq		THEN	desEstEnvLiq
					WHEN	estEnvPenLiq	THEN	confirmadas
					WHEN	estEnvAut		THEN	desEstEnvAut
					WHEN	estEnvRechBanx	THEN	desEstEnvRechBanx
					WHEN	estEnvCan		THEN	desEstEnvCan
					WHEN	estEnvExpor		THEN	desEstEnvExpor
					WHEN	estEnvEnCola	THEN	confirmadas
					WHEN	estEnvOrdError	THEN	desEstEnvRechBanx
					WHEN	estEnvDet		THEN	desEstEnvDet
					WHEN	estEnvTransBanx	THEN	confirmadas
					WHEN	estEnvPeEnv		THEN	desEstEnvPeEnv
					ELSE	Cadena_Vacia	END	AS	EstatusOpe
			FROM SPEIENVIOS SP
				INNER JOIN CUENTASAHO CO ON CO.CuentaAhoID = SP.CuentaAho
				INNER JOIN CLIENTES CTE ON CTE.ClienteID = CO.ClienteID
				INNER JOIN INSTITUCIONES INS ON INS.ClaveParticipaSpei = SP.InstiReceptoraID
			WHERE CTE.ClienteID			= Par_ClienteID
			AND DATE(SP.FechaRecepcion) >= Par_FechaInicial
			AND DATE(SP.FechaRecepcion) <= Par_FechaFinal;
	END IF;

	IF(Par_NumLis = Lis_PendEnviar) THEN
	-- CONSULTA PARA OBTENER LAS ORDENES DE PAGO PENDIENTES PARA ENVIAR A STP
		SELECT
			FNLIMPIACARACTERESSPEI(FNDECRYPTSAFI(SE.NombreOrd)) AS NombreOrd,		SE.TipoCuentaOrd,			FNLIMPIACARACTERESSPEI(FNDECRYPTSAFI(SE.CuentaOrd)) AS CuentaOrd,
			CASE WHEN FNDECRYPTSAFI(SE.RFCOrd) = '' THEN 'ND' ELSE FNDECRYPTSAFI(SE.RFCOrd) END AS RFCOrd ,		FNLIMPIACARACTERESSPEI(FNDECRYPTSAFI(SE.NombreBeneficiario)) AS NombreBeneficiario,
			SE.TipoCuentaBen,																					FNLIMPIACARACTERESSPEI(FNDECRYPTSAFI(SE.CuentaBeneficiario)) AS CuentaBeneficiario,
			CASE WHEN FNDECRYPTSAFI(SE.RFCBeneficiario) = '' THEN 'ND' ELSE FNDECRYPTSAFI(SE.RFCBeneficiario) END AS RFCBeneficiario ,
			SE.AreaEmiteID,								FNLIMPIACARACTERESSPEI(FNDECRYPTSAFI(SE.ConceptoPago)) AS ConceptoPago,
			CONVERT( CASE WHEN FNDECRYPTSAFI(SE.MontoTransferir) = '' THEN '0'
								 ELSE FNDECRYPTSAFI(SE.MontoTransferir) END, DECIMAL(16,2)) AS MontoTransferir,
			SE.IVAPorPagar,			SE.CuentaAho,				SE.Comentario,			DATE_FORMAT(NOW(), '%Y-%m-%d') AS FechaOperacion,
			CASE
				WHEN SE.ReferenciaNum = Entero_Cero THEN 'ND'
				WHEN SE.ReferenciaNum != Entero_Cero THEN SE.ReferenciaNum END AS RefNum,
			CASE
				WHEN SE.ReferenciaCobranza = Entero_Cero THEN 'ND'
				WHEN SE.ReferenciaCobranza != Entero_Cero THEN SE.ReferenciaCobranza END AS ReferenciaCobranza,
			SE.TipoPagoID,			SE.ClavePago,				SE.PrioridadEnvio,		SE.MonedaID,
			SE.ClaveRastreo,		SE.InstiReceptoraID,		SE.UsuarioEnvio,		SE.CausaDevol,
			PS.Topologia,			SE.OrigenOperacion,			SE.Firma,				SE.FolioSpeiID,
			SE.Usuario,				SE.DireccionIP,			SE.Sucursal
		FROM SPEIENVIOS SE, PARAMETROSSPEI PS
			WHERE SE.Estatus = estVer AND SE.PIDTarea = Par_PIDTarea
			ORDER BY SE.PrioridadEnvio, SE.FechaRecepcion ASC;
	END IF;

	-- Fin de SP
END TerminaStore$$
