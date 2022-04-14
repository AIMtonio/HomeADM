-- SP REMESASWSLIS

DELIMITER ;

DROP PROCEDURE IF EXISTS `REMESASWSLIS`;

DELIMITER $$

CREATE PROCEDURE `REMESASWSLIS` (
-- ================================================
-- ----- STORE PARA LA LISTA DE REMESAS --------
-- ================================================
	Par_RemesaWSID          BIGINT(20),         -- Numero de la Remesa
	Par_RemesaFolioID		VARCHAR(45),		-- Indica la Referencia de Pago
	Par_ClabeCobroRemesa	VARCHAR(45),		-- Indica la clave de cobro para la Remesa
	Par_Descripcion			VARCHAR(50),		-- Descripcion de la Busqueda
	Par_Origen				VARCHAR(10),		-- Indica el origen de la informacion a registrar en el sistema

	Par_Estatus				CHAR(1),			-- Estatus de la remesa
	Par_NumLis				TINYINT UNSIGNED,	-- Numero de Lista

	Par_EmpresaID       	INT(11),			-- Parametro de Auditoria ID de la Empresa
    Aud_Usuario         	INT(11),			-- Parametro de Auditoria ID del Usuario
    Aud_FechaActual     	DATETIME,			-- Parametro de Auditoria Fecha Actual
    Aud_DireccionIP     	VARCHAR(15),		-- Parametro de Auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),		-- Parametro de Auditoria Programa
    Aud_Sucursal        	INT(11),			-- Parametro de Auditoria ID de la Sucursal
    Aud_NumTransaccion  	BIGINT(20)  		-- Parametro de Auditoria Numero de la Transaccion
		)
TerminaStore:BEGIN

    -- DECLARACION DE VARIABLES

	-- DECLARACION DE CONSTANTES
	DECLARE Entero_Cero    		INT(11);		-- Entero Cero
    DECLARE Decimal_Cero		DECIMAL(14,2);	-- Decimal Cero
	DECLARE Cadena_Vacia   		CHAR(1);		-- Cadena Vacia
	DECLARE	Fecha_Vacia			DATE;			-- Fecha Vacia
    DECLARE ConstanteSI			CHAR(1);		-- Constante: SI

    DECLARE Est_Nuevo			CHAR(1);		-- Estatus: Nuevo
    DECLARE Est_Revision		CHAR(1);		-- Estatus: En revision Oficial de Cumplimiento
    DECLARE Est_Pagado			CHAR(1);		-- Estatus: Pagado
    DECLARE Est_Rechazado		CHAR(1);		-- Estatus: Rechazado
    DECLARE Desc_EstNuevo		VARCHAR(50);	-- Descripcion Estatus: Nuevo

    DECLARE Desc_EstRevision	VARCHAR(50);	-- Descripcion Estatus: En revision Oficial de Cumplimiento
    DECLARE Desc_EstPagado		VARCHAR(50);	-- Descripcion Estatus: Pagado
    DECLARE Desc_EstRechazado	VARCHAR(50);	-- Descripcion Estatus: Rechazado

	DECLARE Lis_RefereRemesa	INT(11);	-- Lista de Referencias de Remesas (Pantalla Revision de Remesas)
	DECLARE Lis_RemesasWS		INT(11);	-- Lista de Referencias de Remesas (Pantalla ingreso operaciones pago de Remesas)
	DECLARE Lis_RemesasWScve	INT(11);	-- Lista de Referencias de Remesas (Pantalla ingreso operaciones pago de Remesas clave cobro)
	DECLARE Lis_RemesasWSreferencia	INT(11);	-- Lista de Referencias de Remesas ws CONSULTA

	-- ASIGNACION DE CONSTANTES
	SET Entero_Cero			:= 0; 			-- Entero Cero
    SET Decimal_Cero        := 0.00;		-- Decimal Cero
	SET Cadena_Vacia		:= '';    		-- Cadena Vacia
	SET	Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
    SET ConstanteSI			:= 'S';			-- Constante: SI

    SET Est_Nuevo			:= 'N';			-- Estatus: Nuevo
    SET Est_Revision		:= 'R';			-- Estatus: En revision Oficial de Cumplimiento
    SET Est_Pagado			:= 'P';			-- Estatus: Pagado
    SET Est_Rechazado		:= 'C';			-- Estatus: Rechazado
    SET Desc_EstNuevo		:= 'NUEVO';		-- Descripcion Estatus: Nuevo

    SET Desc_EstRevision	:= 'REVISION OFICIAL DE CUMPLIMIENTO';	-- Descripcion Estatus: En revision Oficial de Cumplimiento
    SET Desc_EstPagado		:= 'PAGADO';		-- Descripcion Estatus: Pagado
    SET Desc_EstRechazado	:= 'RECHAZADO';		-- Descripcion Estatus: Rechazado

	SET Lis_RefereRemesa			:= 1;			-- Lista de Referencias de Remesas (Pantalla Revision de Remesas)
	SET Lis_RemesasWS				:= 2;
	SET Lis_RemesasWScve			:= 3;
    SET Lis_RemesasWSreferencia		:= 4;

    -- 1.- Lista de Referencias de Remesas (Pantalla Revision de Remesas)
	IF(Par_NumLis = Lis_RefereRemesa)THEN
		-- SE CREA TABLA TEMPORAL PARA OBTENER LAS REFERENCIAS DE REMESAS
		DROP TABLE IF EXISTS TMPREMESASWSREP;
		CREATE TEMPORARY TABLE TMPREMESASWSREP(
			RemesaWSID				BIGINT(20),
			RemesaFolioID			VARCHAR(45),
			ClienteID 				INT(11),
			UsuarioServicioID 		INT(11),
			NombreCompleto			VARCHAR(200),
			Estatus					VARCHAR(100),
			Orden					INT(11),
			PRIMARY KEY(RemesaFolioID),
			INDEX TMPREMESASWSREP_1 (ClienteID),
			INDEX TMPREMESASWSREP_2 (UsuarioServicioID),
			INDEX TMPREMESASWSREP_3 (NombreCompleto));

		-- SE REGISTRA INFORMACION DE LAS REFERENCIAS DE REMESAS
		INSERT INTO TMPREMESASWSREP(
			RemesaWSID,			RemesaFolioID,			ClienteID,			UsuarioServicioID,							NombreCompleto,
			Estatus,			Orden)
		SELECT
			RemesaWSID,			RemesaFolioID,			ClienteID,			IFNULL(UsuarioServicioID,Entero_Cero),		Cadena_Vacia,
			CASE WHEN Estatus = Est_Revision THEN Desc_EstRevision
				WHEN Estatus = Est_Nuevo THEN Desc_EstNuevo
				WHEN Estatus = Est_Pagado THEN Desc_EstPagado
				WHEN Estatus = Est_Rechazado THEN Desc_EstRechazado END,
			CASE WHEN Estatus = Est_Revision THEN 1
				WHEN Estatus = Est_Nuevo THEN 2
				WHEN Estatus = Est_Pagado THEN 3
				WHEN Estatus = Est_Rechazado THEN 4 END
		FROM REMESASWS
		WHERE Estatus IN(Est_Revision,Est_Nuevo,Est_Pagado,Est_Rechazado)
		ORDER BY RemesaWSID DESC;

		-- SE ACTUALIZA EL NOMBRE COMPLETO DEL CLIENTE
		UPDATE TMPREMESASWSREP Tmp
		INNER JOIN CLIENTES Cli
		ON Cli.ClienteID = Tmp.ClienteID
		SET Tmp.NombreCompleto = IFNULL(Cli.NombreCompleto,Cadena_Vacia)
		WHERE Tmp.ClienteID > Entero_Cero
		AND Tmp.UsuarioServicioID = Entero_Cero;

		-- SE ACTUALIZA EL NOMBRE COMPLETO DEL USUARIO DE SERVICIO
		UPDATE TMPREMESASWSREP Tmp
		INNER JOIN USUARIOSERVICIO Usu
		ON Usu.UsuarioServicioID = Tmp.UsuarioServicioID
		SET Tmp.NombreCompleto = IFNULL(Usu.NombreCompleto,Cadena_Vacia)
		WHERE Tmp.ClienteID = Entero_Cero
		AND Tmp.UsuarioServicioID > Entero_Cero;

		-- SE OBTIENE LA LISTA DE REFERENCIA DE LAS REMESAS
		SELECT RemesaFolioID, NombreCompleto,Estatus
        FROM TMPREMESASWSREP
        WHERE (RemesaFolioID LIKE CONCAT("%", Par_Descripcion, "%")
        	  OR NombreCompleto LIKE CONCAT("%", Par_Descripcion, "%"))
        ORDER BY Orden ASC
		LIMIT 0,15;

	END IF;

    -- 2 LISTA REMESAS WS
    IF(Par_NumLis = Lis_RemesasWS)THEN
		SELECT REM.RemesaFolioID, IF(REM.ClienteID > Entero_Cero, CTE.NombreCompleto, REM.NombreCompleto) AS NombreCompleto, REM.Estatus
		FROM REMESASWS REM
			LEFT JOIN CLIENTES CTE
				ON CTE.ClienteID = REM.ClienteID
			LEFT JOIN USUARIOSERVICIO USU
				ON USU.UsuarioServicioID = REM.UsuarioServicioID
		WHERE REM.Estatus IN(Est_Revision, Est_Nuevo)
			AND REM.FormaPago = 'R'
			AND (REM.RemesaFolioID LIKE CONCAT("%", Par_Descripcion, "%")
			  OR REM.NombreCompleto LIKE CONCAT("%", Par_Descripcion, "%"))
		ORDER BY REM.RemesaWSID ASC
		LIMIT 0,15;

    END IF;

    -- 3 LISTA REMESAS WS por clave cobro
    IF(Par_NumLis = Lis_RemesasWScve)THEN
		SELECT REM.ClabeCobroRemesa AS RemesaFolioID, IF(REM.ClienteID > Entero_Cero, CTE.NombreCompleto, REM.NombreCompleto) AS NombreCompleto, REM.Estatus
		FROM REMESASWS REM
			LEFT JOIN CLIENTES CTE
				ON CTE.ClienteID = REM.ClienteID
			LEFT JOIN USUARIOSERVICIO USU
				ON USU.UsuarioServicioID = REM.UsuarioServicioID
		WHERE REM.Estatus IN(Est_Revision,Est_Nuevo)
			AND REM.FormaPago = 'R'
			AND (REM.ClabeCobroRemesa LIKE CONCAT("%", Par_Descripcion, "%")
			  OR REM.NombreCompleto LIKE CONCAT("%", Par_Descripcion, "%"))
		ORDER BY REM.RemesaWSID ASC
		LIMIT 0,15;

    END IF;

    -- 4 LISTA REMESAS WS /microfinws/ventanilla/remmitanceStatus
    IF(Par_NumLis = Lis_RemesasWSreferencia)THEN
		SELECT REM.NumTransaccion,	REM.TipoIdentiID,	REM.FolioIdentific,		REM.Estatus,	REM.RemesaFolioID,
				REM.Comentarios
		FROM REMESASWS REM
			LEFT JOIN CLIENTES CTE
				ON CTE.ClienteID = REM.ClienteID
			LEFT JOIN USUARIOSERVICIO USU
				ON USU.UsuarioServicioID = REM.UsuarioServicioID
		WHERE REM.Estatus = Par_Estatus
			AND	IF(Par_RemesaFolioID <> Cadena_Vacia,
					REM.RemesaFolioID LIKE CONCAT("%", Par_RemesaFolioID, "%"),
					TRUE
				)
		ORDER BY REM.RemesaWSID ASC;

    END IF;

END TerminaStore$$