-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOCIODEMODEPENDLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOCIODEMODEPENDLIS`;DELIMITER $$

CREATE PROCEDURE `SOCIODEMODEPENDLIS`(
	Par_ProspectoID			int(11),
	Par_ClienteID			int(11),
	Par_TipoLista			tinyint unsigned,

    Aud_Empresa             int,
    Aud_Usuario             int,
    Aud_FechaActual         DateTime,
    Aud_DireccionIP         varchar(15),
    Aud_ProgramaID          varchar(50),
    Aud_Sucursal            int,
    Aud_NumTransaccion      bigint
	)
TerminaStore: BEGIN

 /* Declaracion de Constantes */
DECLARE Entero_Cero         int(11);

DECLARE Var_LisPrinpal      int(11);


Set Entero_Cero             := 0;


Set Var_LisPrinpal          := 1;


if(Par_TipoLista = Var_LisPrinpal) then
        if Par_ClienteID > Entero_Cero then
			-- Modificacion a la lista principal para agregar nuevos campos de ocupacion y edad. Cardinal Sistemas Inteligentes
			SELECT		Soc.ProspectoID,		Soc.ClienteID,			Soc.FechaRegistro,		Soc.TipoRelacionID,		Rel.Descripcion,
						Soc.PrimerNombre,		Soc.SegundoNombre,		Soc.TercerNombre,		Soc.ApellidoPaterno,	Soc.ApellidoMaterno,
						Soc.Edad,				Soc.OcupacionID,
						Ocupa.Descripcion AS OcupacionDescripcion
				FROM	SOCIODEMODEPEND Soc
				INNER JOIN TIPORELACIONES AS Rel ON Soc.TipoRelacionID = Rel.TipoRelacionID
				INNER JOIN OCUPACIONES AS Ocupa ON Soc.OcupacionID = Ocupa.OcupacionID
				WHERE	ClienteID = Par_ClienteID;
			-- Fin de modificacion a la lista principal. Cardinal Sistemas Inteligentes
        else
			-- Modificacion a la lista principal para agregar nuevos campos de de ocupacion y edad. Cardinal Sistemas Inteligentes
			SELECT		Soc.ProspectoID,		Soc.ClienteID,			Soc.FechaRegistro,		Soc.TipoRelacionID,		Rel.Descripcion,
						Soc.PrimerNombre,		Soc.SegundoNombre,		Soc.TercerNombre,		Soc.ApellidoPaterno,	Soc.ApellidoMaterno,
						Soc.Edad,				Soc.OcupacionID,
						Ocupa.Descripcion AS OcupacionDescripcion
				FROM	SOCIODEMODEPEND Soc
				INNER JOIN TIPORELACIONES AS Rel ON Soc.TipoRelacionID = Rel.TipoRelacionID
				INNER JOIN OCUPACIONES AS Ocupa ON Soc.OcupacionID = Ocupa.OcupacionID
				WHERE	ProspectoID = Par_ProspectoID;
			-- Fin de modificacion a la lista principal. Cardinal Sistemas Inteligentes
        end if;

end if;



END TerminaStore$$