-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LINEASCREDITOAGROREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `LINEASCREDITOAGROREP`;
DELIMITER $$

CREATE PROCEDURE `LINEASCREDITOAGROREP`(
	Par_FechaInicio			DATE,				-- Fecha de Inicio
	Par_FechaFin 			DATE,				-- Fecha de Fin
	Par_LineaCreditoID		BIGINT(20),			-- Numero de Linea de Credito
	Par_ClienteID			INT(11),			-- Numero de Cliente
	Par_ProductoCreditoID	INT(11),			-- Numero de Producto de Credito

	Par_SucursalID			INT(11),			-- Numero de Sucursal
	Par_Estatus				CHAR(2),			-- Estatus

	Par_NumReporte			TINYINT UNSIGNED,	-- Numero de Lista

	Aud_EmpresaID			INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Sentencia		VARCHAR(6000);	-- Sentencia de Ejecucion

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);		-- Constante Cadena Vacia
	DECLARE Entero_Cero			INT(11);		-- Constante Entero Cero
	DECLARE Rep_Principal		TINYINT UNSIGNED;-- Reporte Principal
	DECLARE Rep_Creditos		TINYINT UNSIGNED;--

	-- Asignacion de Constantes
	SET Cadena_Vacia			:= '';
	SET	Entero_Cero				:= 0;
	SET Rep_Principal			:= 1;
	SET Rep_Creditos			:= 2;

	-- Asignacion a por IFNULL
	SET Par_LineaCreditoID		:= IFNULL(Par_LineaCreditoID, Entero_Cero);
	SET Par_ClienteID			:= IFNULL(Par_ClienteID, Entero_Cero);
	SET Par_ProductoCreditoID	:= IFNULL(Par_ProductoCreditoID, Entero_Cero);
	SET Par_SucursalID			:= IFNULL(Par_SucursalID, Entero_Cero);
	SET Par_Estatus				:= IFNULL(Par_Estatus,Cadena_Vacia);

	IF(Par_NumReporte = Rep_Principal) THEN

		DROP TABLE IF EXISTS TMP_LINEASCREDITOAGROREP;
		CREATE TEMPORARY TABLE TMP_LINEASCREDITOAGROREP(
			LineaCreditoID		BIGINT(20),
			CuentaID			BIGINT(20),
			FolioContrato 		VARCHAR(150),
			FechaInicio 		DATE,
			FechaVencimiento 	DATE,

			Solicitado 			DECIMAL(14,2),
			Autorizado 			DECIMAL(14,2),
			Dispuesto 			DECIMAL(14,2),
			Pagado 				DECIMAL(14,2),
			SaldoDisponible		DECIMAL(14,2),

			SaldoDeudor			DECIMAL(14,2),
			NumeroCreditos 		INT(11),
			ClienteID 			INT(11),
			NombreCompleto 		VARCHAR(300),
			SucursalID 			INT(11),

			NombreSucurs 		VARCHAR(300),
			ProductoCreditoID	VARCHAR(100),
			Descripcion 		VARCHAR(1000),
			Estatus 			VARCHAR(50),
			TipoLineaAgroID		INT(11) COMMENT 'Tipo de Linea Agro',
		PRIMARY KEY(LineaCreditoID),
		KEY `IDX_TMP_LINEASCREDITOAGROREP_1` (`TipoLineaAgroID`));

		DROP TABLE IF EXISTS TMP_TIPOSLINEASAGROREP;
		CREATE TEMPORARY TABLE TMP_TIPOSLINEASAGROREP(
			TipoLineaAgroID		INT(11) COMMENT 'Tipo de Linea Agro',
			ProductoCreditoID	VARCHAR(100) COMMENT 'Tipo de Producto Agro',
			Descripcion 		VARCHAR(1000) COMMENT 'Descripcion del tipo de Linea',
			ProductoDescripcion VARCHAR(1100) COMMENT 'Descripcion del tipo de Linea',
		PRIMARY KEY(TipoLineaAgroID));

		IF( Par_ProductoCreditoID = Entero_Cero ) THEN

			INSERT INTO TMP_TIPOSLINEASAGROREP (
				TipoLineaAgroID,		ProductoCreditoID,	Descripcion, ProductoDescripcion)
			SELECT
				Tip.TipoLineaAgroID,
				REPLACE(GROUP_CONCAT(Pro.ProducCreditoID),',','\n'),
				REPLACE(GROUP_CONCAT(Pro.Descripcion),',','\n'),
				REPLACE(GROUP_CONCAT(CONCAT(Pro.ProducCreditoID,' - ',Pro.Descripcion)),',','\n')
			FROM TIPOSLINEASAGRO Tip
			INNER JOIN PRODUCTOSCREDITO Pro ON FIND_IN_SET(Pro.ProducCreditoID,Tip.ProductosCredito) > Entero_Cero
			GROUP BY Tip.TipoLineaAgroID;
		ELSE

			INSERT INTO TMP_TIPOSLINEASAGROREP (
				TipoLineaAgroID,		ProductoCreditoID,	Descripcion, ProductoDescripcion)
			SELECT
				Tip.TipoLineaAgroID,
				REPLACE(GROUP_CONCAT(Pro.ProducCreditoID),',','\n'),
				REPLACE(GROUP_CONCAT(Pro.Descripcion),',','\n'),
				REPLACE(GROUP_CONCAT(CONCAT(Pro.ProducCreditoID,' - ',Pro.Descripcion)),',','\n')
			FROM TIPOSLINEASAGRO Tip
			INNER JOIN PRODUCTOSCREDITO Pro ON FIND_IN_SET(Pro.ProducCreditoID,Tip.ProductosCredito) > Entero_Cero
			WHERE Pro.ProducCreditoID = Par_ProductoCreditoID
			GROUP BY Tip.TipoLineaAgroID;
		END IF;

		SET Var_Sentencia :='
			INSERT INTO TMP_LINEASCREDITOAGROREP(

				LineaCreditoID,		CuentaID,			FolioContrato,		FechaInicio,	FechaVencimiento,
				Solicitado,			Autorizado,			Dispuesto,			Pagado,			SaldoDisponible,
				SaldoDeudor,		NumeroCreditos,		ClienteID,			NombreCompleto,	SucursalID,
				NombreSucurs,		ProductoCreditoID,	Descripcion,		Estatus,		TipoLineaAgroID)
			SELECT 	Lin.LineaCreditoID,	Lin.CuentaID,		Lin.FolioContrato,		Lin.FechaInicio,	Lin.FechaVencimiento, ';
		SET Var_Sentencia :=CONCAT( Var_Sentencia, '
					Lin.Solicitado,		Lin.Autorizado,		Lin.Dispuesto,			Lin.Pagado,			Lin.SaldoDisponible, ');
		SET Var_Sentencia :=CONCAT(Var_Sentencia, '
					Lin.SaldoDeudor,	NumeroCreditos,		Lin.ClienteID, 			Cli.NombreCompleto, ');
		SET Var_Sentencia :=CONCAT(Var_Sentencia, '
					Lin.SucursalID,		Suc.NombreSucurs,	Lin.ProductoCreditoID,	Pro.Descripcion, ');
		SET Var_Sentencia :=CONCAT(Var_Sentencia, '
					CASE WHEN Lin.Estatus = "A" THEN "AUTORIZADA" ');
		SET Var_Sentencia :=CONCAT(Var_Sentencia, '
						 WHEN Lin.Estatus = "B" THEN "BLOQUEADA" ');
		SET Var_Sentencia :=CONCAT(Var_Sentencia, '
						 WHEN Lin.Estatus = "C" THEN "CANCELADA" ');
		SET Var_Sentencia :=CONCAT(Var_Sentencia, '
						 WHEN Lin.Estatus = "I" THEN "INACTIVA" ');
		SET Var_Sentencia :=CONCAT(Var_Sentencia, '
						 WHEN Lin.Estatus = "R" THEN "RECHAZADA" ');
		SET Var_Sentencia :=CONCAT(Var_Sentencia, '
						 WHEN Lin.Estatus = "S" THEN "AUTOMÁTICA" ');
		SET Var_Sentencia :=CONCAT(Var_Sentencia, '
						 WHEN Lin.Estatus = "N" THEN "NO AUTOMÁTICA" ');
		SET Var_Sentencia :=CONCAT(Var_Sentencia, '
						 WHEN Lin.Estatus = "E" THEN "VENCIDA" ');
		SET Var_Sentencia :=CONCAT(Var_Sentencia, '
						 ELSE "DESCONOCIDO" END AS Estatus, Lin.TipoLineaAgroID ');
		SET Var_Sentencia :=CONCAT(Var_Sentencia, '
			FROM LINEASCREDITO Lin ');
		SET Var_Sentencia :=CONCAT(Var_Sentencia, '
			INNER JOIN CLIENTES Cli ON Lin.ClienteID = Cli.ClienteID ');
		SET Var_Sentencia :=CONCAT(Var_Sentencia, '
			INNER JOIN SUCURSALES Suc ON Lin.SucursalID = Suc.SucursalID ');
		SET Var_Sentencia :=CONCAT(Var_Sentencia, '
			INNER JOIN PRODUCTOSCREDITO Pro ON Lin.ProductoCreditoID = Pro.ProducCreditoID ');
		SET Var_Sentencia :=CONCAT(Var_Sentencia, '
			WHERE Lin.EsAgropecuario = "S" AND Lin.FechaInicio BETWEEN ? AND ? ');

		IF(Par_LineaCreditoID != Entero_Cero) THEN
			SET Var_Sentencia :=CONCAT(Var_Sentencia, '
			  AND Lin.LineaCreditoID = ', Par_LineaCreditoID);
		END IF;

		IF(Par_ClienteID != Entero_Cero) THEN
			SET Var_Sentencia :=CONCAT(Var_Sentencia, '
			  AND Lin.ClienteID = ', Par_ClienteID);
		END IF;

		IF( Par_SucursalID != Entero_Cero) THEN
			SET Var_Sentencia :=CONCAT(Var_Sentencia, '
			  AND Lin.SucursalID = ', Par_SucursalID);
		END IF;

		IF( Par_Estatus != Cadena_Vacia ) THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,'
			  AND Lin.Estatus = "',Par_Estatus,'"');
		END IF;

		SET Var_Sentencia := CONCAT(Var_Sentencia,'
			ORDER BY Lin.SucursalID, Lin.ProductoCreditoID, Lin.ClienteID;');

		SET @Sentencia	 := (Var_Sentencia);
		SET @FechaInicio := Par_FechaInicio;
		SET @FechaFin	 := Par_FechaFin;

		PREPARE LINEASCREDITOREP FROM @Sentencia;
		EXECUTE LINEASCREDITOREP USING @FechaInicio, @FechaFin;
		DEALLOCATE PREPARE LINEASCREDITOREP;

		SELECT 	LineaCreditoID,		CuentaID,				FolioContrato,		FechaInicio,	FechaVencimiento,
				Solicitado,			Autorizado,				Dispuesto,			Pagado,			SaldoDisponible,
				SaldoDeudor,		NumeroCreditos,			ClienteID,			NombreCompleto,	SucursalID,
				NombreSucurs,		Tip.ProductoCreditoID,
				ProductoDescripcion AS Descripcion,
				Estatus,		Tip.TipoLineaAgroID
		FROM TMP_LINEASCREDITOAGROREP Lin
		INNER JOIN TMP_TIPOSLINEASAGROREP Tip ON Lin.TipoLineaAgroID = Tip.TipoLineaAgroID;

		DROP TABLE IF EXISTS TMP_TIPOSLINEASAGROREP;
		DROP TABLE IF EXISTS TMP_LINEASCREDITOAGROREP;

	END IF;

	if(Par_NumReporte = Rep_Creditos) then
		SELECT 	LineaCreditoID,		CreditoID,		MontoCredito,
				CASE 	WHEN Estatus = 'I' THEN 'INACTIVO'
						WHEN Estatus = 'A' THEN 'AUTORIZADO'
						WHEN Estatus = 'V' THEN 'VIGENTE'
						WHEN Estatus = 'P' THEN 'PAGADO'
						WHEN Estatus = 'C' THEN 'CANCELADO'
						WHEN Estatus = 'B' THEN 'VENCIDO'
						WHEN Estatus = 'K' THEN 'CASTIGADO'
						WHEN Estatus = 'S' THEN 'SUSPENDIDO'
				end Estatus,
				FUNCIONTOTDEUDACRE(CreditoID) as TotalDeuda
		FROM CREDITOS Cre
		WHERE LineaCreditoID=Par_LineaCreditoID;
	end if;

END TerminaStore$$