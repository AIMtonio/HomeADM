-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RIESGOCOMUNCLICRELIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `RIESGOCOMUNCLICRELIS`;
DELIMITER $$

CREATE PROCEDURE `RIESGOCOMUNCLICRELIS`(
# =====================================================================================
# ----- STORED PARA LISTAR LAS SOLICITUDES QUE PRESENTEN UN RIESGO COMUN --------------
# =====================================================================================
	Par_SolicitudID			BIGINT(20),			# Numero de Solicitud
	Par_NumLis				TINYINT UNSIGNED,	# Numero de Lista

	# Parametros de Auditoria
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
	)
TerminaStore: BEGIN


/* Declaracion de Constantes */
DECLARE	Cadena_Vacia			CHAR(1);
DECLARE	Fecha_Vacia				DATE;
DECLARE	Entero_Cero				INT(11);
DECLARE Decimal_Cero			DECIMAL(12,2);
DECLARE	Str_SI					CHAR(1);
DECLARE	Str_NO					CHAR(1);
DECLARE	GarantAutorizada		CHAR(1);
DECLARE	Lis_Principal			CHAR(1);
DECLARE Lis_Riesgos				INT(11);
DECLARE Est_Vigente				CHAR(1);
DECLARE Est_Vencido				CHAR(1);

/* Asignacion de Constantes */
SET	Cadena_Vacia				:= '';			-- Cadena Vacia
SET	Fecha_Vacia					:= '1900-01-01';-- Fecha Vacia
SET	Entero_Cero					:= 0;			-- Entero Cero
SET Decimal_Cero				:= 0.00;		-- Decimal Cero
SET	Str_SI						:= 'S';			-- Cadena de Si
SET	Str_NO						:= 'N';			-- Cadena de No
SET GarantAutorizada			:= 'U';			-- Estatus de Garantia Autorizada
SET	Lis_Principal				:= 1;			-- Lista de creditos que presentan riesgo con una solicitud
SET Lis_Riesgos					:= 2;			-- Lista de solicitud que presentan riesgos
SET Est_Vigente					:= 'V';			-- Estatus Vigente
SET Est_Vencido					:= 'B';			-- Estatus Vencido



/*  LISTA DE RIESGOS POR SOLICITUD DE CREDITO */
IF(Par_NumLis = Lis_Principal) THEN

		(SELECT	Ries.CreditoID, Ries.ConsecutivoID,	Ries.ClienteID,	Cli.NombreCompleto,	Ries.Motivo,	Ries.RiesgoComun,
				Ries.Comentario
		FROM RIESGOCOMUNCLICRE Ries
		INNER JOIN CLIENTES Cli
		ON Ries.ClienteID = Cli.ClienteID
		WHERE	SolicitudCreditoID = Par_SolicitudID
		AND Ries.Procesado = Str_NO)

		UNION

        (SELECT	Ries.CreditoID, Ries.ConsecutivoID,	Ries.ClienteID,	Rel.NombrePersona,	Ries.Motivo,	Ries.RiesgoComun,
				Ries.Comentario
		FROM RIESGOCOMUNCLICRE Ries
		INNER JOIN RELACIONPERSONAS Rel
		ON Ries.NombreCompleto = Rel.NombrePersona
        WHERE	SolicitudCreditoID = Par_SolicitudID
		AND Ries.Procesado = Str_NO);

END IF;

/*  LISTA DE SOLICITUDES QUE PRESENTAN RIESGOS */
IF(Par_NumLis = Lis_Riesgos) THEN

	DELETE FROM RIESGOCOMUNCLI WHERE NumTransaccion = Aud_NumTransaccion;


	# TABLA DE PASO PARA OBTENER LOS DIFERENTES CLIENTES QUE PRESENTAN RIESGO
	DROP TEMPORARY TABLE IF EXISTS RIESGOCOMUNCLISALDOS;
		CREATE TEMPORARY TABLE RIESGOCOMUNCLISALDOS (
		ClienteID		INT(11),
		MontoAcumulado	DECIMAL(14,2),
        NumTransaccion		BIGINT(20)
	) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Monto Acumulado por Cliente';

	# TABLA PARA OBTENER EL MONTO ACUMULADO DE CREDITOS POR CLIENTE
	DROP TEMPORARY TABLE IF EXISTS CALCULASALDOSRIESGO;
		CREATE TEMPORARY TABLE CALCULASALDOSRIESGO (
		ClienteID		INT(11),
		MontoAcumulado	DECIMAL(14,2),
		NumTransaccion		BIGINT(20)
	) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Monto Acumulado por Cliente';


	# SE LLENA LA TABLA RIESGOCOMUNCLI CON LOS POSIBLES RIESGOS QUE TIENE UNA SOLICITUD DE CREDITO
	INSERT INTO RIESGOCOMUNCLI
	(SELECT	Ries.SolicitudCreditoID,	Ries.ConsecutivoID,	Ries.ClienteIDSolicitud AS ClienteIDRel,	CONCAT('C.',Ries.ClienteIDSolicitud),CliR.NombreCompleto AS NombreCompletoRel,	Ries.ClienteID,
			Ries.NombreCompleto,		Ries.CreditoID,		Ries.Motivo,								Ries.RiesgoComun, 							Ries.Procesado,
			Ries.Comentario,			Ries.ParentescoID,	CASE WHEN Ries.ParentescoID <> Entero_Cero THEN Tip.Descripcion
													ELSE 'NINGUNO' END AS Descripcion,
			Ries.Clave,  				Ries.Estatus AS   Estatus, 										Decimal_Cero,
			Par_EmpresaID, Aud_Usuario, Aud_FechaActual, Aud_DireccionIP, Aud_ProgramaID, Aud_Sucursal, Aud_NumTransaccion


		FROM RIESGOCOMUNCLICRE Ries
		LEFT JOIN CLIENTES Cli
		ON Ries.ClienteID = Cli.ClienteID
		INNER JOIN CLIENTES CliR
		ON Ries.ClienteIDSolicitud = CliR.ClienteID
        LEFT JOIN TIPORELACIONES Tip
        ON Ries.ParentescoID = Tip.TipoRelacionID
    		LEFT JOIN SOLICITUDCREDITO Sol On Ries.SolicitudCreditoID = Sol.SolicitudCreditoID
		WHERE	Ries.Procesado = Str_NO AND Sol.Estatus <> 'D' AND Sol.Estatus <> 'R' AND Sol.Estatus <> 'C' )
	
		UNION        
			-- IALDANA T_14117 se cambia Pro.NombreCompleto por Ries.NombreCompleto.
	(SELECT	Ries.SolicitudCreditoID,	Ries.ConsecutivoID,	Ries.ProspectoID AS ClienteIDRel,			CONCAT('P.',Ries.ProspectoID), Pro.NombreCompleto AS NombreCompletoRel,	Ries.ClienteID,
			Ries.NombreCompleto,			Ries.CreditoID,		Ries.Motivo,								Ries.RiesgoComun, 							Ries.Procesado,
			Ries.Comentario,			Ries.ParentescoID,	CASE WHEN Ries.ParentescoID <> Entero_Cero THEN Tip.Descripcion
													ELSE 'NINGUNO' END AS Descripcion,
			Ries.Clave,		 			Ries.Estatus AS Estatus,										Decimal_Cero,
			Par_EmpresaID, Aud_Usuario, Aud_FechaActual, Aud_DireccionIP, Aud_ProgramaID, Aud_Sucursal, Aud_NumTransaccion
            FROM RIESGOCOMUNCLICRE Ries
			INNER JOIN PROSPECTOS Pro
			ON Ries.ProspectoID = Pro.ProspectoID
			 LEFT JOIN CLIENTES Cli -- IALDANA T_16385 Se cambia INNER a LEFT De acuerdo a lo platicado con Julio Quital.
			 ON Ries.ClienteID = Cli.ClienteID
			 LEFT JOIN TIPORELACIONES Tip
			ON Ries.ParentescoID = Tip.TipoRelacionID
			LEFT JOIN SOLICITUDCREDITO Sol On Ries.SolicitudCreditoID = Sol.SolicitudCreditoID
			WHERE	 Ries.Procesado = Str_NO AND Sol.Estatus <> 'D' And Sol.Estatus <> 'R' And Sol.Estatus <> 'C');

	# SE INSERTAN LOS DIFERENTES CLIENTES QUE PRESENTAN RIESGO
	INSERT INTO RIESGOCOMUNCLISALDOS
	(SELECT	DISTINCT(Ries.ClienteIDRel), Decimal_Cero, Ries.NumTransaccion
    FROM RIESGOCOMUNCLI Ries
   WHERE Ries.ClienteIDRel <> Entero_Cero AND Ries.NumTransaccion = Aud_NumTransaccion
    GROUP BY Ries.ClienteIDRel
    );

    # SE OBTIENE EL MONTO ACUMULADO DE CREDITOS QUE TIENEN LOS CLIENTES QUE PRESENTAN RIESGO
    INSERT INTO CALCULASALDOSRIESGO
	(SELECT	Ries.ClienteID,  SUM(SaldoCapVigent + SaldoCapAtrasad + SaldoCapVencido + SaldCapVenNoExi), Ries.NumTransaccion
    FROM RIESGOCOMUNCLISALDOS Ries
    INNER JOIN CREDITOS Cre
	WHERE Ries.ClienteID = Cre.ClienteID
    AND Cre.Estatus IN (Est_Vigente, Est_Vencido)
    AND Ries.NumTransaccion = Aud_NumTransaccion
    GROUP BY Ries.ClienteID);

    # SE ACTUALIZA EL MONTO ACUMULADO DE LA TABLA PRINCIPAL
    UPDATE RIESGOCOMUNCLI R1, CALCULASALDOSRIESGO C1
    SET R1.MontoAcumulado = C1.MontoAcumulado
    WHERE R1.ClienteIDRel = C1.ClienteID AND R1.NumTransaccion = Aud_NumTransaccion;
 
 
	
    DELETE ri.* from RIESGOCOMUNCLI ri
	inner join CREDITOS as cred on ri.CreditoID=cred.CreditoID
    where cred.Estatus='P';
	# SE DEVUELVEN LOS RESULTADOS
	SELECT SolicitudCreditoID, ConsecutivoID, ClienteIDRel, ClienteIDDesc, NombreCompletoRel,
		ClienteID, NombreCompleto, CreditoID, Motivo, RiesgoComun, Procesado, Comentario,
        ParentescoID, Descripcion, Clave, Estatus, MontoAcumulado
    FROM RIESGOCOMUNCLI 
    WHERE NumTransaccion = Aud_NumTransaccion
    ORDER BY SolicitudCreditoID;
    
	DELETE FROM RIESGOCOMUNCLI WHERE NumTransaccion = Aud_NumTransaccion;

END IF;

END TerminaStore$$
