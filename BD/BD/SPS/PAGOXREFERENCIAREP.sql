-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOXREFERENCIAREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOXREFERENCIAREP`;DELIMITER $$

CREATE PROCEDURE `PAGOXREFERENCIAREP`(
	/*SP para el reporte de Pagos por Referencia*/
	Par_FechaInicio					DATE,					-- Fecha Inicio
	Par_FechaFin					DATE,					-- Fecha Fin
	Par_SucursalID					INT(11),				-- Número de Sucursal
	Par_ProductoCreditoID			INT(11),				-- Número de Producto de Crédito
	Par_TipoReporte					TINYINT,				-- Número de Reporte
	/*Parametros de Auditoria*/
	Aud_EmpresaID					INT(11),
	Aud_Usuario						INT(11),
	Aud_FechaActual					DATETIME,
	Aud_DireccionIP					VARCHAR(15),
	Aud_ProgramaID					VARCHAR(50),

	Aud_Sucursal					INT(11),
	Aud_NumTransaccion				BIGINT(12)
)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Control				VARCHAR(50);				-- ID del Control en pantalla
	DECLARE Var_AdjuntoID			INT(11);					-- ID Max de PLDADJUNTOS
	DECLARE Var_RutaArchivosPLD		VARCHAR(200);				-- Ruta del Archivo PLD
	DECLARE Var_Consecutivo 		VARCHAR(200);				-- Numero consecutivo para la imagen a digitalizar
	DECLARE Var_FechaRegistro 		DATE;						-- Fecha en la que se digitalizo el Archivo
	DECLARE Var_Sentencia			VARCHAR(3000);
	DECLARE Var_Condicion			VARCHAR(3000);
	-- Declaracion de constantes
	DECLARE Estatus_Activo			CHAR(1);
	DECLARE Entero_Cero				INT(11);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Cons_NO					CHAR(1);
	DECLARE SalidaSi				CHAR(1);


	-- Asignacion de constantes
	SET Entero_Cero				:=0;							-- Entero Cero
	SET Cadena_Vacia			:= '';							-- Cadena Vacia
	SET Cons_NO					:= 'N';							-- Constante No
	SET SalidaSi				:= 'S';							-- Salida Si


	IF(IFNULL(Par_SucursalID,Entero_Cero)!=Entero_Cero) THEN
		SET Var_Condicion := CONCAT(' AND CRED.Sucursal = ',Par_SucursalID);
	END IF;

	IF(IFNULL(Par_ProductoCreditoID,Entero_Cero)!=Entero_Cero) THEN
		SET  Var_Condicion:= CONCAT(' AND CRED.ProductoCreditoID = ',Par_ProductoCreditoID);
	END IF;

	SET Var_Condicion := IFNULL(Var_Condicion,Cadena_Vacia);
	SET Var_Sentencia := CONCAT(
	'SELECT
	PAG.ClienteID,			PAG.CreditoID,					CRED.CreditoID,			CRED.GrupoID,	GRUP.NombreGrupo,
	CLI.NombreCompleto,		PRO.Descripcion AS NombreProd,	CRED.Sucursal,			CRED.CuentaID,	PAG.SaldoCtaAntesPag,
	PAG.Referencia,			PAG.FechaApli,					PAG.SaldoBloqRefere,
	(IFNULL(DET.MontoCapAtr,0) + IFNULL(DET.MontoCapOrd,0) + IFNULL(DET.MontoCapVen,0)) AS CapitalPag,
	(IFNULL(DET.MontoIntAtr,0) + IFNULL(DET.MontoIntVen,0) + IFNULL(DET.MontoIntOrd,0)) AS InteresPag,
	DET.MontoIntMora AS MoratoriosPag,
	(IFNULL(DET.MontoComision,0)+IFNULL(DET.MontoComAnual,0)) AS ComisionesPag,
	(IFNULL(DET.MontoIVA,0)+IFNULL(DET.MontoIVASeguroCuota,0)) AS IVAPag,
	DET.MontoTotPago AS TotalPag,
	PAG.Estatus,
	PAG.Hora
		FROM PAGOXREFERENCIA AS PAG INNER JOIN CLIENTES AS CLI ON PAG.ClienteID = CLI.ClienteID
		INNER JOIN DETALLEPAGCRE AS DET ON PAG.CreditoID = DET.CreditoID AND PAG.TransaccionID = DET.Transaccion
		LEFT JOIN CREDITOS AS CRED ON PAG.CreditoID = CRED.CreditoID
		LEFT JOIN GRUPOSCREDITO AS GRUP ON CRED.GrupoID = GRUP.GrupoID
		LEFT JOIN PRODUCTOSCREDITO AS PRO ON CRED.ProductoCreditoID = PRO.ProducCreditoID
		WHERE PAG.FechaApli BETWEEN "',Par_FechaInicio,'" AND "',Par_FechaFin,'" ',Var_Condicion,
	' UNION ',
	'SELECT
	PAG.ClienteID,			PAG.CreditoID,					CRED.CreditoID,			CRED.GrupoID,	GRUP.NombreGrupo,
	CLI.NombreCompleto,		PRO.Descripcion AS NombreProd,	CRED.Sucursal,			CRED.CuentaID,	PAG.SaldoCtaAntesPag,
	PAG.Referencia,			PAG.FechaApli,					PAG.SaldoBloqRefere,
	(IFNULL(DET.MontoCapAtr,0) + IFNULL(DET.MontoCapOrd,0) + IFNULL(DET.MontoCapVen,0)) AS CapitalPag,
	(IFNULL(DET.MontoIntAtr,0) + IFNULL(DET.MontoIntVen,0) + IFNULL(DET.MontoIntOrd,0)) AS InteresPag,
	DET.MontoIntMora AS MoratoriosPag,
	(IFNULL(DET.MontoComision,0)+IFNULL(DET.MontoComAnual,0)) AS ComisionesPag,
	(IFNULL(DET.MontoIVA,0)+IFNULL(DET.MontoIVASeguroCuota,0)) AS IVAPag,
	DET.MontoTotPago AS TotalPag,
	PAG.Estatus,
	PAG.Hora
		FROM HISPAGOXREFERENCIA AS PAG INNER JOIN CLIENTES AS CLI ON PAG.ClienteID = CLI.ClienteID
		INNER JOIN DETALLEPAGCRE AS DET ON PAG.CreditoID = DET.CreditoID AND PAG.TransaccionID = DET.Transaccion
		LEFT JOIN CREDITOS AS CRED ON PAG.CreditoID = CRED.CreditoID
		LEFT JOIN GRUPOSCREDITO AS GRUP ON CRED.GrupoID = GRUP.GrupoID
		LEFT JOIN PRODUCTOSCREDITO AS PRO ON CRED.ProductoCreditoID = PRO.ProducCreditoID
		WHERE PAG.FechaApli BETWEEN "',Par_FechaInicio,'" AND "',Par_FechaFin,'" ',Var_Condicion,';'
	);

	SET @Sentencia	= (Var_Sentencia);
	PREPARE SPPAGOXREFERENCIAREP FROM @Sentencia;
	EXECUTE SPPAGOXREFERENCIAREP;
	DEALLOCATE PREPARE SPPAGOXREFERENCIAREP;
END TerminaStore$$