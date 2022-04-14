-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTASUBCLASIFCARTALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTASUBCLASIFCARTALT`;DELIMITER $$

CREATE PROCEDURE `SUBCTASUBCLASIFCARTALT`(



	Par_ConceptoCarID	INT(11),
	Par_ProducCreditoID	INT(11),
	Par_SubCuenta	 	CHAR(6),

	Aud_EmpresaID		INT,
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
)
TerminaStore: BEGIN

	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Entero_Cero			INT;
	DECLARE	Float_Cero			DECIMAL(4,2);
	DECLARE	NumSubCuenta		INT;

	SET	Cadena_Vacia		:= '';
	SET	Entero_Cero			:= 0;
	SET	Float_Cero			:= 0.0;
	SET NumSubCuenta		:= 0;

	IF(IFNULL(Par_ConceptoCarID, Entero_Cero))= Entero_Cero THEN
		SELECT '001' AS NumErr,
			 'El Concepto esta Vacio.' AS ErrMen,
			 'conceptoCarID' AS control;
		LEAVE TerminaStore;
	END IF;

	IF(IFNULL(Par_ProducCreditoID, Entero_Cero))= Entero_Cero THEN
		SELECT '002' AS NumErr,
			 'El Producto esta Vacio.' AS ErrMen,
			 'producCreditoID5' AS control;
		LEAVE TerminaStore;
	END IF;

	IF(IFNULL(Aud_EmpresaID, Entero_Cero))= Entero_Cero THEN
		SELECT '003' AS NumErr,
			 'El Numero de Empresa esta Vacio.' AS ErrMen,
			 'empresaID' AS control;
		LEAVE TerminaStore;
	END IF;

	SET Par_SubCuenta	:= IFNULL(Par_SubCuenta,Cadena_Vacia);
	IF(Par_SubCuenta = Cadena_Vacia) THEN
		SELECT '004' AS NumErr,
			 'La SubCuenta esta Vacia.' AS ErrMen,
			 'subCuenta5' AS control;
		LEAVE TerminaStore;
	END IF;

	IF EXISTS (SELECT ConceptoCarID,ClasificacionID FROM SUBCTASUBCLACART
					WHERE ConceptoCarID = Par_ConceptoCarID
						AND  ClasificacionID=Par_ProducCreditoID) THEN
				SELECT '004' AS NumErr,
					'El Registro ya existe.' AS ErrMen,
					'ProductoCreditoID5' AS control;
				LEAVE TerminaStore;
	END IF;

	SET Aud_FechaActual := NOW();

	INSERT INTO SUBCTASUBCLACART
				VALUES(	Par_ConceptoCarID,	 	Par_ProducCreditoID,	 Par_SubCuenta,
						Aud_EmpresaID,			Aud_Usuario,	 		Aud_FechaActual,	 Aud_DireccionIP,		Aud_ProgramaID,
						Aud_Sucursal,	 		Aud_NumTransaccion);
	SELECT '000' AS NumErr,
		  CONCAT('Subcuenta Agregada Exitosamente: ',
					CONVERT(Par_ConceptoCarID, CHAR))  AS ErrMen,
		  'subCuenta5' AS control;
END TerminaStore$$