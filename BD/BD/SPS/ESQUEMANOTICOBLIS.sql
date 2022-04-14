-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMANOTICOBLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMANOTICOBLIS`;DELIMITER $$

CREATE PROCEDURE `ESQUEMANOTICOBLIS`(

    Par_EsquemaID		INT(11),
	Par_NumList			TINYINT UNSIGNED,

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)


	)
TerminaStore:BEGIN


    DECLARE Lis_EsqNotiCob	INT(11);
    DECLARE Lis_etapasCob	INT(11);



    SET Lis_EsqNotiCob 	:= 1;
    SET Lis_etapasCob 	:= 2;


	IF(Par_NumList = Lis_EsqNotiCob) THEN
		SELECT 	`EsquemaID`, 		`DiasAtrasoIni`, 	`DiasAtrasoFin`,	`NumEtapa`, 		`EtiquetaEtapa`,
				`Accion`, 			`FormatoID`
		FROM ESQUEMANOTICOB;
    END IF;

	IF(Par_NumList = Lis_etapasCob) THEN
		SELECT 	`EsquemaID`, 		`NumEtapa`, 		`EtiquetaEtapa`
		FROM ESQUEMANOTICOB;
    END IF;

END TerminaStore$$