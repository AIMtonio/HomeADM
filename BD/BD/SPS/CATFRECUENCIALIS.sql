-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATFRECUENCIALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATFRECUENCIALIS`;DELIMITER $$

CREATE PROCEDURE `CATFRECUENCIALIS`(
	/*SP PARA LISTAR LAS FRECUENCUAS DE LOS PRODUCTOS DE CRÉDITO*/
    Par_ProductoCredito	INT(11),					-- Numero de producto de credito
	Par_Descripcion		VARCHAR(50),				-- Descripción del plazo
	Par_NumLis			TINYINT UNSIGNED,			-- Numero de lista
	/*AUDITORIA*/
	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,

	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN
	-- Declaracion de constantes
	DECLARE	Cadena_Vacia		CHAR(1);			-- Cadena Vacia
	DECLARE	C_Quincenal			CHAR(1);			-- Frecuencia Quincenal
	DECLARE	C_Mensual			CHAR(1);			-- Frecuencia Mensual
	DECLARE	Fecha_Vacia			DATE;				-- Fecha vacia
	DECLARE	Entero_Cero			INT(11);			-- Entero Cero
	DECLARE	Lis_Todas			INT(11);			-- Lista para el multiselect, trae todas las frecuencias sin filtrar por prod.
	DECLARE	Lis_Combo			INT(11);			-- Lista para el combo trae todas los plazos
	DECLARE	Lis_Desembolsos		INT(11);			-- Lista solo para la parametrizacion de desembolsos de credito

	-- Asignacion de constantes
	SET	Cadena_Vacia		:= '';
	SET	C_Quincenal			:= 'Q';
	SET	C_Mensual			:= 'M';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Lis_Todas			:= 1;
	SET	Lis_Combo			:= 3;
	SET	Lis_Desembolsos		:= 4;

	-- Todas las frecuencias sin filtrar por producto
	IF(Par_NumLis = Lis_Todas) THEN
		SELECT
			FrecuenciaID,		Orden,		Dias,		DescSingular,		DescPlural,
			UPPER(DescInfinitivo) AS DescInfinitivo
		FROM CATFRECUENCIAS AS Cat
		ORDER BY Orden;
	END IF;

	-- Lista del combo
	IF(Par_NumLis = Lis_Combo) THEN
		SELECT
			FrecuenciaID,							Orden,		Dias,		DescSingular,		DescPlural,
			UPPER(DescInfinitivo) AS DescInfinitivo
			FROM CATFRECUENCIAS AS Cat INNER JOIN
				CALENDARIOPROD AS Cal ON LOCATE(CONCAT(',',Cat.FrecuenciaID,','),CONCAT(',',Cal.Frecuencias,','))>0
			WHERE Cal.ProductoCreditoID=Par_ProductoCredito
				ORDER BY Orden;
	END IF;
    	-- Lista del combo
	IF(Par_NumLis = Lis_Desembolsos) THEN
		SELECT
			FrecuenciaID,							Orden,		Dias,		DescSingular,		DescPlural,
			UPPER(DescInfinitivo) AS DescInfinitivo
			FROM CATFRECUENCIAS AS Cat INNER JOIN
				CALENDARIOPROD AS Cal ON LOCATE(CONCAT(',',Cat.FrecuenciaID,','),CONCAT(',',Cal.Frecuencias,','))>0
			WHERE Cal.ProductoCreditoID=Par_ProductoCredito
				AND FrecuenciaID IN(C_Quincenal,C_Mensual)
				ORDER BY Orden;
	END IF;

END TerminaStore$$