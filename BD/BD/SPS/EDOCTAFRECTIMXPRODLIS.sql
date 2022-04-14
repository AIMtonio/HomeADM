-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAFRECTIMXPRODLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAFRECTIMXPRODLIS`;
DELIMITER $$

CREATE PROCEDURE `EDOCTAFRECTIMXPRODLIS`(
-- SP PARA LISTAR Catalogo de Frecuencias de Timbrado por Producto
	Par_FrecuenciaID			CHAR(50),			-- FRECUENCIA
    Par_ProductoID				INT(11),			-- PRODUCTO
	Par_TipoLista				TINYINT UNSIGNED,	-- TIPO DE LISTA   
   
    -- PARAMATROS DE AUDITORIA
	Aud_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),   
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore: BEGIN

-- DECLARACION DE CONSTANTES
DECLARE	Lista_Principal	 INT(11);
DECLARE	Lista_Foranea	 INT(11);
DECLARE	Lista_Frecuencia INT(11);
DECLARE	Cadena_Vacia	 VARCHAR(1);
DECLARE	Fecha_Vacia		 DATE;
DECLARE	Entero_Cero		 INT(11);
DECLARE	SalidaSI         CHAR(1);
DECLARE	SalidaNO         CHAR(1);

-- ASIGNACION DE CONSTANTES
SET Cadena_Vacia		:= '';
SET Fecha_Vacia			:= '1900-01-01';
SET Entero_Cero			:= 0;
SET	SalidaSI        	:= 'S';
SET	SalidaNO        	:= 'N';
SET	Lista_Principal     := 1;
SET	Lista_Foranea   	:= 2; 
SET Lista_Frecuencia    := 3;
			
-- LISTA PRINCIPAL
IF(IFNULL(Par_TipoLista, Entero_Cero) = Lista_Principal) THEN
	SELECT PRO.ProducCreditoID, PRO.Descripcion
		FROM PRODUCTOSCREDITO PRO
		LEFT OUTER JOIN  EDOCTAFRECTIMXPROD EDO ON EDO.ProducCreditoID = PRO.ProducCreditoID
		WHERE EDO.ProducCreditoID IS NULL
		LIMIT 15;
     
END IF;

-- LISTA FRECUENCIA
IF(IFNULL(Par_TipoLista, Entero_Cero) = Lista_Foranea) THEN
	SELECT CASE IFNULL(EDO.FrecuenciaID, "") WHEN "M" THEN "MENSUAL"
											 WHEN "E" THEN "SEMESTRAL"
			ELSE "" END AS FrecuenciaID,
			EDO.ProducCreditoID,
            PRO.Descripcion
		FROM EDOCTAFRECTIMXPROD EDO
		INNER JOIN PRODUCTOSCREDITO PRO ON EDO.ProducCreditoID = PRO.ProducCreditoID
		WHERE EDO.FrecuenciaID = Par_FrecuenciaID
        LIMIT 15;
END IF;

IF(IFNULL(Par_TipoLista, Entero_Cero) = Lista_Frecuencia) THEN
	SELECT EDO.ProducCreditoID, PRO.Descripcion
		FROM EDOCTAFRECTIMXPROD EDO
		INNER JOIN PRODUCTOSCREDITO PRO ON EDO.ProducCreditoID = PRO.ProducCreditoID
		WHERE EDO.FrecuenciaID = Par_FrecuenciaID;
END IF;



END TerminaStore$$