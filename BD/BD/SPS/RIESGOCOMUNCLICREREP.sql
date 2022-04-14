-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RIESGOCOMUNCLICREREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `RIESGOCOMUNCLICREREP`;DELIMITER $$

CREATE PROCEDURE `RIESGOCOMUNCLICREREP`(
# =====================================================================================
# 			----- STORED QUE GENERA EL REPORTE DE RIESGO COMUN -----------------
# =====================================================================================
	Par_ClienteID			INT(11),		-- Numero de Cliente
    Par_Estatus				CHAR(1),		-- Estatus P:Pendiente  R:Revisado
    Par_RiesgoComun			CHAR(1),		-- Riesgo Comun S:Si; N:No
    Par_PersRela			CHAR(1), 		-- Persona Relacionada S:Si; N:No
    Par_Procesado			CHAR(1),		-- Procesado  S: Si;  N:No
    Par_SucursalID			INT(11),		-- ID de la sucursal

    Par_EmpresaID			INT(11),		-- Parametro de Auditoria
	Aud_Usuario				INT(11),		-- Parametro de Auditoria
	Aud_FechaActual			DATE,			-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal			INT(11),		-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de Auditoria
)
TerminaStore:BEGIN

	-- DECLARACION DE VARIABLES
	DECLARE Var_Sentencia 		VARCHAR(60000);

	-- DECLARACION DE CONSTANTES
	DECLARE Entero_Cero 		INT(11);
	DECLARE Cadena_Vacia 		CHAR(1);
	DECLARE Decimal_Cero		DECIMAL(12,2);
    DECLARE	Str_NO				CHAR(1);
    DECLARE Est_Vigente			CHAR(1);
	DECLARE Est_Vencido			CHAR(1);
	DECLARE Desc_Si				CHAR(1);

	-- ASIGNACION DE CONSTANTES
	SET Entero_Cero				:= 0;		-- Constante Entero Cero
    SET Decimal_Cero			:= 0.00;	-- DECIMAL Cero
	SET Cadena_Vacia			:='';		-- Constante Cadena Vacia
    SET	Str_NO					:= 'N';		-- Cadena de No
    SET Est_Vigente				:= 'V';		-- Estatus Vigente
	SET Est_Vencido				:= 'B';		-- Estatus Vencido
	SET Desc_Si					:= 'S';		-- Descripcion SI

	# TABLA PRINCIPAL QUE ALMANCENA LOS POSIBLES RIESGOS DE UNA SOLICITUD
	DROP TEMPORARY TABLE IF EXISTS RIESGOCOMUNCLIREP;
		CREATE TEMPORARY TABLE RIESGOCOMUNCLIREP (
		SolicitudCreditoID	BIGINT(20)  	NOT NULL COMMENT 'ID de la Solicitud de Credito',
		ConsecutivoID		INT(11)  		NOT NULL COMMENT 'Consecutivo de Riesgo',
        ClienteID			INT(11) 		NOT NULL COMMENT 'ID del Cliente con el que se presenta el riesgo',
		NombreCompleto		VARCHAR(200) 	NOT NULL COMMENT 'Nombre del Cliente con el que se presenta riesgo',
		ClienteIDRel		INT(11) 		NOT NULL COMMENT 'ID del Cliente que realiza la solicitud',
		NombreCompletoRel	VARCHAR(200) 	NOT NULL COMMENT 'Nombre del Cliente que realiza la solicitud',
		CreditoID			BIGINT(12) 		NOT NULL COMMENT 'Credito con el que se presenta el riesgo',
		Motivo				VARCHAR(100) 	NOT NULL COMMENT 'Motivo de Riesgo',
		RiesgoComun			CHAR(2)			NOT NULL COMMENT 'Indica si la solicitud presenta Riesgo',
		PersRelacionada		CHAR(2)			NOT NULL COMMENT 'Indica si la Solicitud presenta Persona Relacionada',
		Procesado			CHAR(2) 		NOT NULL COMMENT 'Indica si la solicitud ya fue procesada',
		Comentario			TEXT 			NOT NULL COMMENT 'Comentarios de la solicitud',
		ParentescoID		INT(11) 		NOT NULL COMMENT 'Clave del Parentesco de la Persona Relacionada',
		Descripcion			VARCHAR(50)		NOT NULL COMMENT 'Descripcion del Parentesco de la persona relacionada',
		Clave 				INT(11) 		NOT NULL COMMENT 'Clave',
		Estatus				VARCHAR(10) 	NOT NULL COMMENT 'Estatus de la Solicitud',
		MontoAcumulado		DECIMAL(14,2)	NOT NULL COMMENT 'Monto Acumulado de Creditos por Cliente'
	) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Riesgo por Cliente';


	-- TABLA DE PASO PARA OBTENER LOS DIFERENTES CLIENTES QUE PRESENTAN RIESGO
	DROP TEMPORARY TABLE IF EXISTS RIESGOCOMUNCLISALDOSREP;
		CREATE TEMPORARY TABLE RIESGOCOMUNCLISALDOSREP (
		ClienteID		INT(11),
		MontoAcumulado	DECIMAL(14,2)
	) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Monto Acumulado por Cliente';

	-- TABLA PARA OBTENER EL MONTO ACUMULADO DE CREDITOS POR CLIENTE
	DROP TEMPORARY TABLE IF EXISTS CALCULASALDOSRIESGOREP;
		CREATE TEMPORARY TABLE CALCULASALDOSRIESGOREP (
		ClienteID		INT(11),
		MontoAcumulado	DECIMAL(14,2)
	) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Monto Acumulado por Cliente';

	-- SE CREA LA SENTENCIA PARA INSERTAR LOS REGISTROS
	SET Var_Sentencia := '
		INSERT	INTO RIESGOCOMUNCLIREP(
			SolicitudCreditoID,		ConsecutivoID,		ClienteID,      NombreCompleto,			ClienteIDRel,
            NombreCompletoRel,	CreditoID,			Motivo,			RiesgoComun,			PersRelacionada,
            Procesado,			Comentario,  		ParentescoID,	Descripcion, 			Clave,
            Estatus, 			MontoAcumulado) ';

    -- SE LLENA LA TABLA RIESGOCOMUNCLI CON LOS POSIBLES RIESGOS QUE TIENE UNA SOLICITUD DE CREDITO
	SET Var_Sentencia	:=  CONCAT(Var_Sentencia,'
		(SELECT	Ries.SolicitudCreditoID, 	Ries.ConsecutivoID, 	Ries.ClienteIDSolicitud, 	Cli.NombreCompleto, 	Ries.ClienteID,
				Ries.NombreCompleto, 		Ries.CreditoID, 		Ries.Motivo, 				CASE WHEN Ries.RiesgoComun = "S" THEN "SI" ELSE "NO" END,
				CASE WHEN Ries.Motivo="PERSONA RELACIONADA" THEN "SI" ELSE "NO" END, 	CASE WHEN Ries.Procesado = "S" THEN "SI" ELSE "NO" END,
				Ries.Comentario, 			Ries.ParentescoID,		CASE WHEN Ries.ParentescoID <> 0 THEN Tip.Descripcion ELSE "NINGUNO" END,
				Ries.Clave,  				CASE WHEN Ries.Estatus = "P" THEN "PENDIENTE" ELSE "REVISADO" END, 0.00
		FROM RIESGOCOMUNCLICRE Ries
		INNER JOIN CLIENTES Cli
		ON Ries.ClienteIDSolicitud = Cli.ClienteID ');
	IF(IFNULL(Par_ClienteID,Entero_Cero)<>Entero_Cero)THEN
		SET Var_Sentencia	:=  CONCAT(Var_Sentencia,' AND Ries.ClienteIDSolicitud=',Par_ClienteID);
	END IF;

	IF(IFNULL(Par_Estatus,Cadena_Vacia)<>Cadena_Vacia)THEN
		SET Var_Sentencia	:=  CONCAT(Var_Sentencia,' AND Ries.Estatus="',Par_Estatus,'"');
	END IF;

	IF(IFNULL(Par_RiesgoComun,Cadena_Vacia)<>Cadena_Vacia)THEN
		SET Var_Sentencia	:=  CONCAT(Var_Sentencia,' AND Ries.RiesgoComun="',Par_RiesgoComun,'"');
	END IF;

	IF(IFNULL(Par_PersRela,Cadena_Vacia)<>Cadena_Vacia)THEN
		IF(Par_PersRela=Desc_Si)THEN
			SET Var_Sentencia	:=  CONCAT(Var_Sentencia,' AND Ries.Motivo="PERSONA RELACIONADA"');
		ELSE
			SET Var_Sentencia	:=  CONCAT(Var_Sentencia,' AND Ries.Motivo<>"PERSONA RELACIONADA"');
		END IF;
	END IF;

	IF(IFNULL(Par_Procesado,Cadena_Vacia)<>Cadena_Vacia)THEN
		SET Var_Sentencia	:=  CONCAT(Var_Sentencia,' AND Ries.Procesado="',Par_Procesado,'"');
	END IF;

	SET Var_Sentencia := CONCAT(Var_Sentencia,'
        LEFT JOIN TIPORELACIONES Tip
        ON Ries.ParentescoID = Tip.TipoRelacionID)
    UNION
		(SELECT	Ries.SolicitudCreditoID, 	Ries.ConsecutivoID, 	Ries.ProspectoID, 		Pro.NombreCompleto, 		Ries.ClienteID,
				Cli.NombreCompleto,			Ries.CreditoID, 		Ries.Motivo,			CASE WHEN Ries.RiesgoComun = "S" THEN "SI" ELSE "NO" END,
				CASE WHEN Ries.Motivo="PERSONA RELACIONADA" THEN "SI" ELSE "NO" END, 		CASE WHEN Ries.Procesado = "S" THEN "SI" ELSE "NO" END,
				Ries.Comentario,			Ries.ParentescoID,		CASE WHEN Ries.ParentescoID <> 0 THEN Tip.Descripcion ELSE "NINGUNO" END,
				Ries.Clave,		 			CASE WHEN Ries.Estatus = "P" THEN "PENDIENTE" ELSE "REVISADO" END AS Estatus, 0.00
			FROM RIESGOCOMUNCLICRE Ries
			INNER JOIN PROSPECTOS Pro
			ON Ries.ProspectoID = Pro.ProspectoID ');
	IF(IFNULL(Par_ClienteID,Cadena_Vacia)<>Cadena_Vacia)THEN
		SET Var_Sentencia	:=  CONCAT(Var_Sentencia,' AND Ries.ClienteIDSolicitud="',Par_ClienteID,'"');
	END IF;

	IF(IFNULL(Par_Estatus,Cadena_Vacia)<>Cadena_Vacia)THEN
		SET Var_Sentencia	:=  CONCAT(Var_Sentencia,' AND Ries.Estatus="',Par_Estatus,'"');
	END IF;

	IF(IFNULL(Par_RiesgoComun,Cadena_Vacia)<>Cadena_Vacia)THEN
		SET Var_Sentencia	:=  CONCAT(Var_Sentencia,' AND Ries.RiesgoComun="',Par_RiesgoComun,'"');
	END IF;

	IF(IFNULL(Par_PersRela,Cadena_Vacia)<>Cadena_Vacia)THEN
		IF(Par_PersRela=Desc_Si)THEN
			SET Var_Sentencia	:=  CONCAT(Var_Sentencia,' AND Ries.Motivo="PERSONA RELACIONADA"');
		ELSE
			SET Var_Sentencia	:=  CONCAT(Var_Sentencia,' AND Ries.Motivo<>"PERSONA RELACIONADA"');
		END IF;
	END IF;

	IF(IFNULL(Par_Procesado,Cadena_Vacia)<>Cadena_Vacia)THEN
		SET Var_Sentencia	:=  CONCAT(Var_Sentencia,' AND Ries.Procesado="',Par_Procesado,'"');
	END IF;

	SET Var_Sentencia := CONCAT(Var_Sentencia,'
			INNER JOIN CLIENTES Cli
			ON Ries.ClienteID = Cli.ClienteID
			LEFT JOIN TIPORELACIONES Tip
			ON Ries.ParentescoID = Tip.TipoRelacionID); ');

	SET @Sentencia	= (Var_Sentencia);

	PREPARE STREPRIESGO FROM @Sentencia;
	 EXECUTE STREPRIESGO;
	DEALLOCATE PREPARE STREPRIESGO;


	-- SE INSERTAN LOS DIFERENTES CLIENTES QUE PRESENTAN RIESGO
	INSERT INTO RIESGOCOMUNCLISALDOSREP
	(SELECT	DISTINCT(Ries.ClienteID), Decimal_Cero
    FROM RIESGOCOMUNCLIREP Ries
   WHERE Ries.ClienteID <> Entero_Cero
    GROUP BY Ries.ClienteID
    );

    -- SE OBTIENE EL MONTO ACUMULADO DE CREDITOS QUE TIENEN LOS CLIENTES QUE PRESENTAN RIESGO
    INSERT INTO CALCULASALDOSRIESGOREP
	(SELECT	Ries.ClienteID,  SUM(SaldoCapVigent + SaldoCapAtrasad + SaldoCapVencido + SaldCapVenNoExi)
    FROM RIESGOCOMUNCLISALDOSREP Ries
    INNER JOIN CREDITOS Cre
	WHERE Ries.ClienteID = Cre.ClienteID
    AND Cre.Estatus IN (Est_Vigente, Est_Vencido)
    GROUP BY Ries.ClienteID);

    -- SE ACTUALIZA EL MONTO ACUMULADO DE LA TABLA PRINCIPAL
    UPDATE RIESGOCOMUNCLIREP R1, CALCULASALDOSRIESGOREP C1
    SET R1.MontoAcumulado = C1.MontoAcumulado
    WHERE R1.ClienteID = C1.ClienteID;

	-- SE DEVUELVEN LOS RESULTADOS


	IF (Par_SucursalID <> Entero_Cero) THEN
	SELECT
		RC.SolicitudCreditoID, 		RC.ConsecutivoID,			RC.ClienteID,			RC.NombreCompleto,			RC.ClienteIDRel,
		RC.NombreCompletoRel,		RC.CreditoID,				RC.Motivo,				RC.RiesgoComun,				RC.PersRelacionada,
		RC.Procesado,				RC.Comentario,				RC.ParentescoID,		RC.Descripcion,				RC.Clave,
		RC.Estatus,					RC.MontoAcumulado,			SUC.SucursalID,			SUC.NombreSucurs
	 FROM RIESGOCOMUNCLIREP  RC
	INNER JOIN SOLICITUDCREDITO SOL ON RC.SolicitudCreditoID = SOL.SolicitudCreditoID
	INNER JOIN SUCURSALES SUC ON SOL.SucursalID = SUC.SucursalID
	WHERE SUC.SucursalID = Par_SucursalID;
	END IF;

	IF (Par_SucursalID = Entero_Cero) THEN
	SELECT
		RC.SolicitudCreditoID, 		RC.ConsecutivoID,			RC.ClienteID,			RC.NombreCompleto,			RC.ClienteIDRel,
		RC.NombreCompletoRel,		RC.CreditoID,				RC.Motivo,				RC.RiesgoComun,				RC.PersRelacionada,
		RC.Procesado,				RC.Comentario,				RC.ParentescoID,		RC.Descripcion,				RC.Clave,
		RC.Estatus,					RC.MontoAcumulado,			SUC.SucursalID,			SUC.NombreSucurs
	 FROM RIESGOCOMUNCLIREP  RC
	INNER JOIN SOLICITUDCREDITO SOL ON RC.SolicitudCreditoID = SOL.SolicitudCreditoID
	INNER JOIN SUCURSALES SUC ON SOL.SucursalID = SUC.SucursalID;
	END IF;


END	TerminaStore$$