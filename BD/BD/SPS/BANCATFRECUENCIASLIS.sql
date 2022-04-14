-- BANCATFRECUENCIASLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS BANCATFRECUENCIASLIS;
DELIMITER $$


CREATE PROCEDURE BANCATFRECUENCIASLIS (
-- SP PARA LISTAR LAS FRECUENCUAS DE LOS PRODUCTOS DE CRÉDITO
    Par_ProductoCredito	INT(11),					-- Numero de producto de credito
	Par_NumLis			TINYINT UNSIGNED,			-- Numero de lista

	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,

	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)

TerminaStore: BEGIN
	-- DECLARACION DE CONSTANTES
	DECLARE	Lis_Principal		INT(11);    -- Lista principal de Categorias de Frecuencias por Producto de Credito
	
	-- ASIGNACION DE CONSTANTES
	SET	Lis_Principal		:= 1;
	

	-- LISTA CATEGORIAS DE FRECUENCIAS POR PRODUCTO
	IF(Par_NumLis = Lis_Principal) THEN
		SELECT
			FrecuenciaID,		Orden,		Dias,		DescSingular,		DescPlural,
			UPPER(DescInfinitivo) AS DescInfinitivo
			FROM CATFRECUENCIAS AS Cat INNER JOIN
				CALENDARIOPROD AS Cal ON LOCATE(CONCAT(',',Cat.FrecuenciaID,','),CONCAT(',',Cal.Frecuencias,',')) > 0
			WHERE Cal.ProductoCreditoID=Par_ProductoCredito
				ORDER BY Orden;
	END IF;
    
END TerminaStore$$