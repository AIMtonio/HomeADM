-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMACARGOSDISPLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMACARGOSDISPLIS`;DELIMITER $$

CREATE PROCEDURE `ESQUEMACARGOSDISPLIS`(
/* CONSULTA EL ESQUEMA COBRO POR DISPOSICION DE CREDITO. */
	Par_ProductoCreditoID		INT(11), 		-- ID del producto de Crédito.
	Par_TipoLista				TINYINT UNSIGNED,
    /* Parametros de Auditoria */
	Aud_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,

	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(60),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de constantes
DECLARE Cadena_Vacia	CHAR(1);
DECLARE Entero_Cero		INT;
DECLARE Decimal_Cero	DECIMAL(12,2);
DECLARE SalidaSI		CHAR(1);
DECLARE SalidaNO		CHAR(1);
DECLARE Con_Principal	INT;
DECLARE TipoDispSPEI	CHAR(1);
DECLARE TipoDispCHEQUE	CHAR(1);
DECLARE TipoDispORDEN 	CHAR(1);
DECLARE TipoDispEFECT	CHAR(1);
DECLARE NombDispSPEI	VARCHAR(20);
DECLARE NombDispCHEQUE	VARCHAR(20);
DECLARE NombDispORDEN 	VARCHAR(20);
DECLARE NombDispEFECT	VARCHAR(20);
DECLARE TipoMonto	 	CHAR(1);
DECLARE TipoPorcentaje	CHAR(1);
DECLARE DescripMonto 	VARCHAR(20);
DECLARE DescripPorcen	VARCHAR(20);


-- Asignacion  de constantes
SET	Cadena_Vacia	:= '';		-- CADENA VACIA
SET	Entero_Cero		:= 0;		-- ENTERO CERO
SET	Decimal_Cero	:= 0.0;		-- DECIMAL CERO
SET	SalidaSI		:= 'S';		-- SALIDA SI
SET	SalidaNO		:= 'N';		-- SALIDA NO
SET	Con_Principal	:= 1;		-- CONSULTA PRINCIPAL NO 1
SET TipoDispSPEI	:= 'S';		-- Tipo de dispersion SPEI.
SET TipoDispCHEQUE	:= 'C';		-- Tipo de dispersion CHEQUE.
SET TipoDispORDEN 	:= 'O';		-- Tipo de dispersion ORDEN DE PAGO.
SET TipoDispEFECT	:= 'E';		-- Tipo de dispersion EFECTIVO.
SET NombDispSPEI	:= 'SPEI';	-- Nombre del tipo de dispersión SPEI.
SET NombDispCHEQUE	:= 'CHEQUE';-- Nombre del tipo de dispersión CHEQUE.
SET NombDispORDEN 	:= 'ORDEN DE PAGO';	-- Nombre del tipo de dispersión ORDEN DE PAGO.
SET NombDispEFECT	:= 'EFECTIVO';-- Nombre del tipo de dispersión EFECTIVO.
SET TipoMonto	 	:= 'M';		-- Tipo cargo por Monto.
SET TipoPorcentaje	:= 'P';		-- Tipo cargo por Porcentaje.
SET DescripMonto 	:= 'MONTO';	-- Descripción del Tipo cargo por Monto.
SET DescripPorcen	:= 'PORCENTAJE';-- Descripción del Tipo cargo por Porcentaje.

SET Aud_FechaActual := NOW();

IF(Par_TipoLista = Con_Principal) THEN
	SELECT
		E.ProductoCreditoID,		E.InstitucionID,		E.NombInstitucion,
		IF(E.TipoCargo = TipoPorcentaje, CONCAT(E.MontoCargo, ' %'), FORMAT(E.MontoCargo,2)) AS MontoCargo,
		CASE E.TipoDispersion
			WHEN TipoDispSPEI THEN NombDispSPEI
			WHEN TipoDispCHEQUE THEN NombDispCHEQUE
			WHEN TipoDispORDEN THEN NombDispORDEN
			WHEN TipoDispEFECT THEN NombDispEFECT
			ELSE Cadena_Vacia
		END AS TipoDispersion,
		CASE E.TipoCargo
			WHEN TipoMonto THEN DescripMonto
			WHEN TipoPorcentaje THEN DescripPorcen
			ELSE Cadena_Vacia
		END AS TipoCargo,
		IF(N.Descripcion IS NULL, 'TODAS', UPPER(N.Descripcion)) AS Nivel
		FROM ESQUEMACARGOSDISP E
			LEFT OUTER JOIN NIVELCREDITO N ON E.Nivel = N.NivelID
			WHERE ProductoCreditoID = Par_ProductoCreditoID;
END IF;

END TerminaStore$$