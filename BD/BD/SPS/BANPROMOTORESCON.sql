-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BANPROMOTORESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `BANPROMOTORESCON`;
DELIMITER $$


CREATE PROCEDURE `BANPROMOTORESCON`(
    Par_PromotorID  		BIGINT,
    Par_UsuarioID   		INT(11),
    Par_SucursalID  		INT,
    Par_NumCon      		TINYINT UNSIGNED,
    Par_EmpresaID   		INT(11),


    Aud_Usuario         	INT(11),
    Aud_FechaActual     	DATETIME,
    Aud_DireccionIP     	VARCHAR(15),
    Aud_ProgramaID      	VARCHAR(50),
    Aud_Sucursal       	 	INT(11),
    Aud_NumTransaccion  	BIGINT(20)

)

TerminaStore: BEGIN


DECLARE     Cadena_Vacia    		CHAR(1);
DECLARE     Fecha_Vacia     		DATE;
DECLARE     Entero_Cero     		INT;
DECLARE     Con_Principal   		INT;
DECLARE     Con_Foranea     		INT;
DECLARE     Con_ProActivo 			INT;
DECLARE     Con_PromtAct			INT;
DECLARE		Con_UsuarioID			INT;		-- Consulta por usuario id


DECLARE     Estatus_Activo			CHAR(1);
DECLARE 	Desc_Activo				VARCHAR(10);
DECLARE     Estatus_Baja			CHAR(1);
DECLARE 	Desc_Baja				VARCHAR(10);
DECLARE     Con_PromCapSocioMenor 	INT(11);
DECLARE     Captacion				CHAR(2);
DECLARE     EjecAmbos				CHAR(1);
DECLARE     Bloqueado				CHAR(1);
DECLARE     UsuarioInactivo 		CHAR(2);
DECLARE     UsuarioActivo			CHAR(2);
DECLARE     PromotorActivo			CHAR(2);
DECLARE     PromotorInac			CHAR(2);
DECLARE     MismoPromotor			CHAR(1);
DECLARE     Var_EstatusUsu			CHAR(1);
DECLARE     Var_SucursalID			INT(11);
DECLARE     Var_PromotorID			INT(11);
DECLARE     Var_AplicaPromotor		CHAR(2);
DECLARE     Var_TienePromotor   	INT(11);
DECLARE     Var_MismoPromotor   	INT(11);
DECLARE     Var_UsuarioEstatus  	INT(11);


SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET Con_Principal   := 1;
SET Con_Foranea     := 2;
SET Con_PromtAct    := 3 ;
SET Con_ProActivo   := 4;
SET Con_PromCapSocioMenor := 6;
SET	Con_UsuarioID		:= 7;		-- Devuelve la información del promotor

SET Estatus_Activo      :='A';
SET Desc_Activo			:= 'ACTIVO';
SET Estatus_Baja   		:='B';
SET Desc_Baja			:='BAJA';
SET Captacion           :='CA';
SET EjecAmbos           :='A';
SET Bloqueado           :='B';
SET UsuarioInactivo     :='UI';
SET UsuarioActivo       :='UA';
SET PromotorActivo      :='PA';
SET PromotorInac        :='PI';
SET MismoPromotor       :='M';


	IF(Par_NumCon = Con_Principal) THEN
		SELECT  PRO.PromotorID,   		PRO.NombrePromotor,		PRO.NombreCoordinador,		PRO.Telefono,     		PRO.Correo,
				PRO.Celular,  			PRO.SucursalID,			PRO.UsuarioID,    			PRO.NumeroEmpleado,		PRO.Estatus,
				PRO.ExtTelefonoPart,	PRO.AplicaPromotor,		PRO.GestorID,				SUC.NombreSucurs,
				IF(PRO.Estatus = Estatus_Activo, Desc_Activo, IF(PRO.Estatus = Estatus_Baja, Desc_Baja, Cadena_Vacia)) AS DescEstatus
		FROM PROMOTORES PRO
		INNER JOIN SUCURSALES SUC ON SUC.SucursalID = PRO.SucursalID
		WHERE PRO.PromotorID = Par_PromotorID;
	END IF;
	
	-- Consulta la informacion del promotor por medio del usuarioID
	IF(Par_NumCon = Con_UsuarioID) THEN
		SELECT  `PromotorID`,   `NombrePromotor`,   `NombreCoordinador`,
				`Telefono`,     `Correo`,       `Celular`,  `SucursalID`,
				`UsuarioID`,    `NumeroEmpleado`,`Estatus`, `ExtTelefonoPart`,
				`AplicaPromotor`,`GestorID`
		FROM PROMOTORES
		WHERE  UsuarioID = Par_UsuarioID;
	END IF;
END TerminaStore$$
