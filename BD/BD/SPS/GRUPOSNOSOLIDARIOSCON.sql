-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GRUPOSNOSOLIDARIOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `GRUPOSNOSOLIDARIOSCON`;DELIMITER $$

CREATE PROCEDURE `GRUPOSNOSOLIDARIOSCON`(
    Par_GrupoID         BIGINT(12),
    Par_NoConsulta      INT,

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion BIGINT(20)

        )
TerminaStore: BEGIN



DECLARE Con_Principal INT;

SET Con_Principal   :=  1;

ManejoErrores: BEGIN
 IF(Par_NoConsulta = Con_Principal)THEN
    SELECT  GrupoID,        NombreGrupo,    FechaRegistro,  SucursalID,     NumIntegrantes,
            PromotorID,     LugarReunion,   DiaReunion,     HoraReunion,    AhoObligatorio,
            PlazoCredito,   CostoAusencia,  AhorroCompro,   MoraCredito,    EstadoID,
            MunicipioID,    Ubicacion,      Estatus
    FROM GRUPOSNOSOLIDARIOS
    WHERE GrupoID=Par_GrupoID;

 END IF;
END ManejoErrores;

END TerminaStore$$