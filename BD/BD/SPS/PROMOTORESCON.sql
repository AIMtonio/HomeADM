-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROMOTORESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PROMOTORESCON`;
DELIMITER $$


CREATE PROCEDURE `PROMOTORESCON`(
    Par_PromotorID  BIGINT,
    Par_UsuarioID   INT(11),
    Par_SucursalID  INT,
    Par_NumCon      TINYINT UNSIGNED,
    Par_EmpresaID   INT,


    Aud_Usuario         INT,
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT

)

TerminaStore: BEGIN


DECLARE     Cadena_Vacia    CHAR(1);
DECLARE     Fecha_Vacia     DATE;
DECLARE     Entero_Cero     INT;
DECLARE     Con_Principal   INT;
DECLARE     Con_Foranea     INT;
DECLARE     Con_ProActivo   INT;
DECLARE     Con_PromtAct          INT;
DECLARE     Estatus_Activo       CHAR(1);
DECLARE     Estatus_NoActivo     CHAR(1);
DECLARE     Con_PromCapSocioMenor INT;
DECLARE     Captacion       CHAR(2);
DECLARE     EjecAmbos       CHAR(1);
DECLARE     Bloqueado       CHAR(1);
DECLARE     UsuarioInactivo CHAR(2);
DECLARE     UsuarioActivo   CHAR(2);
DECLARE     PromotorActivo  CHAR(2);
DECLARE     PromotorInac    CHAR(2);
DECLARE     MismoPromotor   CHAR(1);
DECLARE     Var_EstatusUsu  CHAR(1);
DECLARE     Var_SucursalID  INT(11);
DECLARE     Var_PromotorID  INT(11);
DECLARE     Var_AplicaPromotor  CHAR(2);
DECLARE     Var_TienePromotor   INT(11);
DECLARE     Var_MismoPromotor   INT(11);
DECLARE     Var_UsuarioEstatus  INT(11);
DECLARE Con_PromotorPorSucursal INT(11);


SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET Con_Principal   := 1;
SET Con_Foranea     := 2;
SET Con_PromtAct    := 3 ;
SET Con_ProActivo   := 4;
SET Con_PromCapSocioMenor := 6;
SET Estatus_Activo      :='A';
SET Estatus_NoActivo    :='N';
SET Captacion           :='CA';
SET EjecAmbos           :='A';
SET Bloqueado           :='B';
SET UsuarioInactivo     :='UI';
SET UsuarioActivo       :='UA';
SET PromotorActivo      :='PA';
SET PromotorInac        :='PI';
SET MismoPromotor       :='M';
SET Con_PromotorPorSucursal := 9;


IF(Par_NumCon = Con_Principal) THEN
    SELECT  `PromotorID`,   `NombrePromotor`,   `NombreCoordinador`,
            `Telefono`,     `Correo`,       `Celular`,  `SucursalID`,
            `UsuarioID`,    `NumeroEmpleado`,`Estatus`, `ExtTelefonoPart`,
            `AplicaPromotor`,`GestorID`
    FROM PROMOTORES
    WHERE  PromotorID = Par_PromotorID;
END IF;


IF(Par_NumCon = Con_Foranea) THEN
    SELECT  `PromotorID`,       `NombrePromotor`, `SucursalID`, `Estatus`
    FROM PROMOTORES
    WHERE  PromotorID = Par_PromotorID;
END IF;



IF(Par_NumCon = Con_PromtAct) THEN

SET Var_TienePromotor := (SELECT COUNT(PromotorID)
                                FROM PROMOTORES
                                WHERE UsuarioID=Par_UsuarioID);

IF(Var_TienePromotor>0 ) THEN
    SET Var_MismoPromotor := IFNULL((SELECT PromotorID
                                    FROM PROMOTORES
                                    WHERE PromotorID=Par_PromotorID AND UsuarioID=Par_UsuarioID),0);

    IF(Var_MismoPromotor!=Par_PromotorID ) THEN
        IF(EXISTS(SELECT PromotorID FROM PROMOTORES
            WHERE UsuarioID = Par_UsuarioID AND Estatus = Estatus_Activo)) THEN
            SELECT PromotorActivo;
            LEAVE TerminaStore;
        ELSE
            SELECT PromotorInac;
        END IF;
    ELSE
        IF(Par_PromotorID=0) THEN
                IF(EXISTS(SELECT PromotorID FROM PROMOTORES
                    WHERE UsuarioID = Par_UsuarioID AND Estatus = Estatus_Activo)) THEN
                    SELECT PromotorActivo;
                    LEAVE TerminaStore;
                ELSE
                    SELECT PromotorInac;
                END IF;
        ELSE
            SELECT MismoPromotor;
        END IF;

    END IF;
ELSE
        IF(EXISTS(SELECT UsuarioID FROM USUARIOS
            WHERE UsuarioID = Par_UsuarioID AND Estatus = Estatus_Activo)) THEN
                SELECT UsuarioActivo;
        ELSE
                SELECT UsuarioInactivo;
        END IF;
END IF;

END IF;

IF(Par_NumCon = Con_ProActivo) THEN
    SELECT  `PromotorID`,   `NombrePromotor`,   `SucursalID`,   `Estatus`
    FROM PROMOTORES
    WHERE  PromotorID = Par_PromotorID
        AND Estatus = Estatus_Activo;
END IF;

IF(Par_NumCon = Con_Foranea) THEN
    SELECT  `PromotorID`,       `NombrePromotor`, `SucursalID`, `Estatus`
    FROM PROMOTORES
    WHERE  PromotorID = Par_PromotorID;
END IF;


IF(Par_NumCon = Con_PromCapSocioMenor) THEN
    SELECT SucursalID, PromotorID,AplicaPromotor
        INTO Var_SucursalID, Var_PromotorID,Var_AplicaPromotor
        FROM PROMOTORES
        WHERE PromotorID =Par_PromotorID;
    SET Var_SucursalID :=IFNULL(Var_SucursalID,Entero_Cero);
    SET Var_PromotorID :=IFNULL(Var_PromotorID,Entero_Cero);
    SET Var_AplicaPromotor :=IFNULL(Var_AplicaPromotor,Cadena_Vacia);

IF(Var_AplicaPromotor != 'N')THEN
    SELECT PromotorID, NombrePromotor, Var_SucursalID, Var_PromotorID, Var_AplicaPromotor
        FROM PROMOTORES
        WHERE  PromotorID = Par_PromotorID AND Estatus = Estatus_Activo AND (AplicaPromotor = Captacion OR AplicaPromotor = EjecAmbos);
ELSE
    SELECT Entero_Cero AS PromotorID,Cadena_Vacia AS NombrePromotor, Var_SucursalID,Var_PromotorID, Var_AplicaPromotor;
END IF;
END IF;

	-- 9.- Consulta el promotor por sucursal
	IF(Par_NumCon = Con_PromotorPorSucursal) THEN
		SELECT
			PromotorID,	NombrePromotor,	SucursalID,	Estatus
		FROM PROMOTORES
		WHERE PromotorID = Par_PromotorID
			AND Estatus = Estatus_Activo
			AND SucursalID = Par_SucursalID;
	END IF;

END TerminaStore$$