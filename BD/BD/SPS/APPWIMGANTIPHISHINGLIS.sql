-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APPWIMGANTIPHISHINGLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `APPWIMGANTIPHISHINGLIS`;

DELIMITER $$
CREATE PROCEDURE `APPWIMGANTIPHISHINGLIS`(

	Par_ImagenPhishingID	BIGINT(20),
	Par_TamanioLista		INT(11),
	Par_PosicionInicial 	INT(11),

    Par_NumLis			TINYINT UNSIGNED,

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
	)

TerminaStore: BEGIN

    DECLARE Lis_Principal 	INT(11);
    DECLARE Est_Activo	  	CHAR(1);
    DECLARE Entero_Cero 	INT(11);

    SET Lis_Principal 		:= 1;
    SET Est_Activo	  		:= 'A';
    SET Entero_Cero 		:= 0;

    IF(Par_NumLis = Lis_Principal) THEN

		IF(Par_TamanioLista = Entero_Cero) THEN
			SELECT COUNT(ImagenPhishingID)
				INTO Par_TamanioLista
				FROM APPWIMGANTIPHISHING;
		END IF;

        SELECT ImagenPhishingID, ImagenBinaria, Descripcion,Estatus
			FROM APPWIMGANTIPHISHING
			WHERE Estatus=Est_Activo
				AND ImagenPhishingID = IF (Par_ImagenPhishingID > Entero_Cero, Par_ImagenPhishingID,ImagenPhishingID)
			ORDER BY  ImagenPhishingID
			LIMIT Par_PosicionInicial, Par_TamanioLista;
    END IF;

END TerminaStore$$