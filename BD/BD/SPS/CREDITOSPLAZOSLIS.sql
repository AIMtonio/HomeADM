-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSPLAZOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOSPLAZOSLIS`;DELIMITER $$

CREATE PROCEDURE `CREDITOSPLAZOSLIS`(
	/*SP PARA LISTAR LOS PLAZOS DE LOS PRODUCTOS DE CRÉDITO*/
	Par_ProductoCredID	INT(11),					-- ID del producto de credito
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
	DECLARE	Cadena_Vacia		CHAR(1);		-- Cadena Vacia
	DECLARE	Fecha_Vacia			DATE;			-- Fecha vacia
	DECLARE	Entero_Cero			INT(11);			-- Entero Cero
	DECLARE Frec_Mes			CHAR(1);			-- frecuencia mensual
	DECLARE	Lis_Combo			INT(11);			-- Lista para el combo trae todas los plazos
	DECLARE	Lis_PlazoMes		INT(11);			-- Lista que trae todos los plazos que su frecuencia sea mensual
	DECLARE	Lis_PlazoProducto	INT(11);			-- Lista todos los plazos de un producto
    DECLARE Lis_CreditosAut		INT(11);			-- Lista los plazos exclusivos para creditos automaticos por inversion
	DECLARE Lis_CreditosAho		INT(11);			-- Lista los plazos exclusivos para creditos automaticos por ahorro

	-- Asignacion de constantes
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET Frec_Mes			:= 'M';
	SET	Entero_Cero			:= 0;
	SET	Lis_Combo			:= 3;
	SET Lis_PlazoMes		:= 4;
	SET Lis_PlazoProducto	:= 5;
    SET Lis_CreditosAut		:= 6;
    SET Lis_CreditosAho		:= 7;

	-- Lista del combo
	IF(Par_NumLis = Lis_Combo) THEN
		SELECT	`PlazoID`,		`Descripcion`, Dias
		FROM CREDITOSPLAZOS
		ORDER BY Dias;
	END IF;

	-- Lista los productos que su frecuencia sea por mes
	IF(Par_NumLis = Lis_PlazoMes) THEN
		SELECT	PlazoID, Descripcion, Dias
			FROM CREDITOSPLAZOS
			WHERE UPPER(Frecuencia) = Frec_Mes
			ORDER BY Dias ASC;
	END IF;

	-- Lista los plazos parametrizados en un producto de credito
	IF(Par_NumLis = Lis_PlazoProducto) THEN
		SELECT
			Cre.PlazoID,	Cre.Descripcion,	Cre.Dias,	Cal.Frecuencias
		FROM CALENDARIOPROD AS Cal INNER JOIN CREDITOSPLAZOS AS Cre
			ON LOCATE(CONCAT(',',Cre.PlazoID,','),CONCAT(',',Cal.PlazoID,','))> Entero_Cero
		WHERE Cal.ProductoCreditoID=Par_ProductoCredID
			ORDER BY Cre.Dias ASC;
	END IF;

    -- Lista los plazos especificos para creditos automaticos por inversion
	IF(Par_NumLis = Lis_CreditosAut) THEN
		SELECT	`PlazoID`,		`Descripcion`, Dias
		FROM CREDITOSPLAZOS
        WHERE Descripcion LIKE '%Dias(s)%'
		ORDER BY Dias;

	END IF;

	-- Lista los plazos especificos para creditos automaticos por ahorro
	IF(Par_NumLis = Lis_CreditosAho) THEN
		SELECT	`PlazoID`,		`Descripcion`, Dias
		FROM CREDITOSPLAZOS
        WHERE Descripcion NOT LIKE '%Dias(s)%'
		ORDER BY Dias;

	END IF;

END TerminaStore$$