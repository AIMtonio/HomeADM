-- SPEIRECEPCIONESLIS
DELIMITER ;

DROP PROCEDURE IF EXISTS `SPEIRECEPCIONESLIS`;

DELIMITER $$

CREATE PROCEDURE `SPEIRECEPCIONESLIS`(
# =====================================================================================
# ------- STORE PARA LISTAR LAS RECEPCION SPEI ---------
# =====================================================================================
	Par_NumRecep		BIGINT(20),					-- Numero de recepcion
	Par_Estatus			CHAR(1),					-- Estatus SAFI

	Par_NumLis			TINYINT UNSIGNED,			-- Tipo de consulta

/* Parámetros de Auditoria */
	Par_EmpresaID		INT(11),					-- Parametro de Auditoria
	Aud_Usuario			INT(11),					-- Parametro de Auditoria
	Aud_FechaActual		DATETIME,					-- Parametro de Auditoria
	Aud_DireccionIP		VARCHAR(20),				-- Parametro de Auditoria
	Aud_ProgramaID		VARCHAR(50),				-- Parametro de Auditoria
	Aud_Sucursal		INT(11),					-- Parametro de Auditoria
	Aud_NumTransaccion	BIGINT(20)					-- Parametro de Auditoria
)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_FechaSis		DATE;				-- fecha de sistema

	-- Declaracion de constantes
	DECLARE Cadena_Vacia		CHAR(1);			-- Cadena vacia
	DECLARE Fecha_Vacia			DATE;				-- Fecha vacia
	DECLARE Entero_Cero			INT(11);			-- Entero vacio
	DECLARE Estatus_Pen			CHAR(1);			-- Estatus Pendiente
	DECLARE Lis_Principal		INT(11);			-- Lista principal
	DECLARE Lis_Recepciones		INT(11);			-- Lista de Recepciones
	DECLARE estRegistrado		CHAR(1);			-- Indicador de estatus Registrado
	DECLARE estAbonado			CHAR(1);			-- Indicador de estatus Abonado
	DECLARE estDevuelta			CHAR(1);			-- Indicador de estatus Devuelto
	DECLARE desEstRegistrado	VARCHAR(15);		-- Descripcion de estatus Registrado
	DECLARE desEstAbonado		VARCHAR(15);		-- Descripcion de estatus Abonado
	DECLARE desEstDevuelta		VARCHAR(15);		-- Descripcion de estatus Devuelto

	-- Asignacion de constantes
	SET Cadena_Vacia		:= '';					-- Cadena Vacia
	SET Fecha_Vacia			:= '1900-01-01';		-- Fecha Vacia
	SET Entero_Cero			:= 0;					-- Entero Cero
	SET Estatus_Pen			:= 'P';					-- Estatus pendiente
	SET Lis_Principal		:= 1; 					-- Lista principal
	SET Lis_Recepciones		:= 3;					-- Lista las Recepciones
	SET estRegistrado		:= 'R';					-- Estatus Registrado
	SET estAbonado			:= 'A';					-- Estatus Abonado
	SET estDevuelta			:= 'D';					-- Estatus Devuelta
	SET desEstRegistrado	:= 'REGISTRADA';		-- Descripcion Registrada
	SET desEstAbonado		:= 'ABONADA';			-- Descripcion Abonada
	SET desEstDevuelta		:= 'DEVOLUCION';		-- Descripcion Devolucion
	SET Var_FechaSis		:= (SELECT FechaSistema FROM PARAMETROSSIS);	-- Fecha del sistema

	IF(Par_NumLis = Lis_Principal) THEN
		SELECT
			SR.FolioSpeiRecID,												FNDECRYPTSAFI(SR.NombreOrd) AS NombreOrd,						FORMAT(CONVERT(FNDECRYPTSAFI(SR.MontoTransferir) , DECIMAL(16,2)),2) AS MontoTransferir,
			SR.TipoCuentaBen,												SR.InstiReceptoraID,											ISP.Descripcion,
			FNDECRYPTSAFI(SR.NombreBeneficiario) AS NombreBeneficiario,		FNDECRYPTSAFI(SR.CuentaBeneficiario) AS CuentaBeneficiario,		SR.Folio
		FROM SPEIRECEPCIONES SR INNER JOIN INSTITUCIONESSPEI ISP ON SR.InstiReceptoraID = ISP.InstitucionID;
	END IF;

	IF(Par_NumLis = Lis_Recepciones) THEN
		(SELECT FechaOperacion, FORMAT(SUM(CONVERT(FNDECRYPTSAFI(MontoTransferir), DECIMAL(16,2))),2) AS Monto, COUNT(Estatus) AS Cantidad,
			CASE Estatus	WHEN estRegistrado THEN desEstRegistrado
							WHEN estAbonado THEN desEstAbonado
							ELSE Cadena_Vacia END AS Estatus
		FROM SPEIRECEPCIONES
			WHERE FechaOperacion = Var_FechaSis
		GROUP BY Estatus, FechaOperacion)
		UNION
		(SELECT FechaOperacion, FORMAT(SUM(CONVERT(FNDECRYPTSAFI(MontoTransferir), DECIMAL(16,2))),2) AS Monto, COUNT(Estatus) AS Cantidad,
				desEstDevuelta AS Estatus
		FROM SPEIRECEPCIONES
			WHERE TipoPagoID = Entero_Cero
				AND FechaOperacion = Var_FechaSis
		GROUP BY TipoPagoID, FechaOperacion);
	END IF;

END TerminaStore$$