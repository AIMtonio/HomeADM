-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OPCIONESROLCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `OPCIONESROLCON`;
DELIMITER $$


CREATE PROCEDURE `OPCIONESROLCON`(
    Par_RolID           INT,
	Par_OpcionMenuID	INT(11),
    Par_NumCon          TINYINT UNSIGNED,
    Par_EmpresaID       INT,

    Aud_Usuario         INT,
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT

)

TerminaStore: BEGIN


DECLARE Var_OpcionMenuID    INT;
DECLARE Var_Recurso         VARCHAR(150);
DECLARE Var_DescriRol       VARCHAR(150);
DECLARE Var_Roles           TEXT;
DECLARE Var_NumOpcion       int;


-- Declaracion de Constantes
DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE Entero_Cero     INT;
DECLARE Con_Principal   INT;
DECLARE Con_Foranea     INT;
DECLARE Con_PorRol      INT;
DECLARE Con_Menu      	INT;
DECLARE Con_OpcionMenu	INT;


DECLARE CURSORRECURSOS CURSOR FOR
    SELECT OpcionMenuID, Recurso
        FROM OPCIONESMENU
        WHERE Recurso != "enConstruccion.htm";

DECLARE CURSORPERFIL CURSOR FOR
    SELECT Rol.Descripcion
        FROM OPCIONESROL Opc,
             ROLES Rol
        WHERE Opc.RolID = Rol.RolID
          AND Opc.OpcionMenuID  = Var_OpcionMenuID
          GROUP BY Rol.Descripcion;


SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Con_Menu        := 4;

IF(Par_NumCon = Con_Menu) THEN
    CREATE TEMPORARY TABLE TMPRECURSOROL(
        `Tmp_Recurso`   VARCHAR(100),
        `Tmp_Roles`     TEXT   );

    SET Var_Roles   = Cadena_Vacia;

    OPEN CURSORRECURSOS;
    BEGIN
        DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
        LOOP

        FETCH CURSORRECURSOS INTO
            Var_OpcionMenuID,   Var_Recurso;

            SET Var_Roles   = Cadena_Vacia;
            set Var_NumOpcion := 1;

            OPEN CURSORPERFIL;
            BEGIN
                DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
                LOOP

                FETCH CURSORPERFIL INTO
                    Var_DescriRol;

                    if Var_NumOpcion > 1 then
                        SET  Var_Roles = CONCAT(Var_Roles, ",");
                    end if;

                    SET  Var_Roles = CONCAT(Var_Roles, Var_DescriRol);
                    set Var_NumOpcion := Var_NumOpcion + 1;

                END LOOP;
            END;
            CLOSE CURSORPERFIL;

            INSERT TMPRECURSOROL VALUES(
                Var_Recurso, Var_Roles  );

        END LOOP;
    END;
    CLOSE CURSORRECURSOS;

    SELECT  `Tmp_Recurso`, `Tmp_Roles`
        FROM TMPRECURSOROL;

    DROP TABLE TMPRECURSOROL;

END IF;


END TerminaStore$$