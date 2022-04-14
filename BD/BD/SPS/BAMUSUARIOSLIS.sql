-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BAMUSUARIOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `BAMUSUARIOSLIS`;DELIMITER $$

CREATE PROCEDURE `BAMUSUARIOSLIS`(
-- SP para listar los los usuarios de banca movil

	Par_Nombre		    VARCHAR(45),
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

	/* Declaracion de Constantes */

    DECLARE Lis_Nombre INT;						-- Lista de usuarios en base al nombre
	DECLARE Lis_Correo INT;						-- Lista de usuarios en base al mail

    /* Asignacion de Constantes */

    SET Lis_Nombre := 1;
    SET Lis_Correo := 2;


    IF(Par_NumLis = Lis_Nombre) THEN
        SELECT cli.ClienteID AS ClienteID, NombreCompleto
        FROM BAMUSUARIOS AS bam INNER JOIN CLIENTES AS cli
        WHERE Email  LIKE CONCAT("%", Par_Nombre, "%")AND cli.ClienteID = bam.ClienteID
        LIMIT 0, 15;
    END IF;

        IF(Par_NumLis = Lis_Correo) THEN
        SELECT cli.ClienteID AS ClienteID,Email, NombreCompleto
        FROM BAMUSUARIOS AS bam INNER JOIN CLIENTES AS cli
        WHERE Email  LIKE CONCAT("%", Par_Nombre, "%")AND cli.ClienteID = bam.ClienteID
        LIMIT 0, 15;
    END IF;


END TerminaStore$$