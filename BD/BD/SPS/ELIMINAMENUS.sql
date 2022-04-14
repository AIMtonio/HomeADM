-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ELIMINAMENUS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ELIMINAMENUS`;
DELIMITER $$


CREATE PROCEDURE `ELIMINAMENUS`(
-- --------------------------------------------------------------------
-- SP PARA ELIMINAR MENUS
-- --------------------------------------------------------------------
	Par_NumCon			TINYINT UNSIGNED,				-- recibe la consulta

	Par_OpcionMenuID	INT,							-- recibe ID del menu a eliminar
	Par_MicroBD			VARCHAR(50),					-- recibe el nombre de la base de datos de microfin a usar
	Par_PrincipalBD		VARCHAR(50),					-- recibe el nombre de la base de datos de principal

	Par_Salida			CHAR(1),						-- Campo a la que hace referencia
    INOUT Par_NumErr	INT,							-- Parametro del numero de Error
    INOUT Par_ErrMen	VARCHAR(400),					-- Parametro del Mensaje de Error


	Par_EmpresaID		INT,
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
	)

TerminaStore:BEGIN

	/*DECLARACION DE CONSTANTES */
	DECLARE Var_Control			VARCHAR(50);
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT;
	DECLARE Menu				INT;					-- Elimina el id referente a MENUSAPLICACION con su contenido GRUPOSMENU Y OPCIONESMENU
	DECLARE Grupo_menu			INT;					-- Elimina el id referente a GRUPOSMENU con su contenido OPCIONESMENU
	DECLARE Opciones_Menu		INT;					-- Elimina el id del registro de OPCIONESMENU
	DECLARE Var_Sentencia		VARCHAR(65535);			-- Guarda la sentencia
	DECLARE Con_SalidaSI		CHAR(1);



	/*ASIGNACION DE CONSTANTES */
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET Menu				:= 1;
	SET Grupo_menu			:= 2;
	SET Opciones_Menu		:= 3;
	SET Con_SalidaSI		:= 'S';



	ManejoErrores:BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr  := 999;
			SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-USUARIOSVAL');
			SET Var_Control := 'SQLEXCEPTION';
		END;


	/*CONSULTA PRINCIPAL */

	IF(Par_NumCon = Menu) THEN
		SET FOREIGN_KEY_CHECKS=0;

		SET Var_Sentencia	:=	CONCAT('
			DELETE  ',Par_MicroBD,'.MENUSAPLICACION ,',Par_MicroBD,'.GRUPOSMENU ,',Par_MicroBD,'.OPCIONESMENU, ',Par_MicroBD,'.OPCIONESROL, ', Par_PrincipalBD,'.OPCIONESROL
			FROM 	 	',Par_MicroBD,'.MENUSAPLICACION
			INNER JOIN ',Par_MicroBD,'.GRUPOSMENU 			ON ',Par_MicroBD,'.MENUSAPLICACION.MenuID = ',Par_MicroBD,'.GRUPOSMENU.MenuID
			INNER JOIN ',Par_MicroBD,'.OPCIONESMENU 		ON ',Par_MicroBD,'.GRUPOSMENU.GrupoMenuID = ',Par_MicroBD,'.OPCIONESMENU.GrupoMenuID
			INNER JOIN ',Par_MicroBD,'.OPCIONESROL			ON ',Par_MicroBD,'.OPCIONESMENU.OpcionMenuID = ',Par_MicroBD,'.OPCIONESROL.OpcionMenuID
			INNER JOIN ',Par_PrincipalBD,'.OPCIONESROL		ON ',Par_MicroBD,'.OPCIONESROL.OpcionMenuID = ',Par_PrincipalBD,'.OPCIONESROL.OpcionMenuID
			WHERE ',Par_MicroBD,'.MENUSAPLICACION.MenuID = ',Par_OpcionMenuID,';');

		SET @Sentencia := Var_Sentencia;
		PREPARE ELIMINAOPCIONESROL FROM @Sentencia;
		EXECUTE ELIMINAOPCIONESROL;
		SET FOREIGN_KEY_CHECKS=1;

		SET Par_NumErr		:=	1;
		SET Par_ErrMen		:=	'MENUSAPLICACION ha sido eliminado con exito';
		SET Var_Control		:= 'MenuID';
		LEAVE ManejoErrores;

	END IF;


	IF(Par_NumCon = Grupo_menu) THEN
		SET FOREIGN_KEY_CHECKS=0;

		SET Var_Sentencia	:=	CONCAT('
			DELETE  ',Par_MicroBD,'.GRUPOSMENU ,	',Par_MicroBD,'.OPCIONESMENU, 	',Par_MicroBD,'.OPCIONESROL,  ',Par_PrincipalBD,'.OPCIONESROL
			FROM 	   ',Par_MicroBD,'.MENUSAPLICACION
			INNER JOIN ',Par_MicroBD,'.GRUPOSMENU 		ON ',Par_MicroBD,'.MENUSAPLICACION.MenuID = ',Par_MicroBD,'.GRUPOSMENU.MenuID
			INNER JOIN ',Par_MicroBD,'.OPCIONESMENU 	ON ',Par_MicroBD,'.GRUPOSMENU.GrupoMenuID = ',Par_MicroBD,'.OPCIONESMENU.GrupoMenuID
			INNER JOIN ',Par_MicroBD,'.OPCIONESROL		ON ',Par_MicroBD,'.OPCIONESMENU.OpcionMenuID = ',Par_MicroBD,'.OPCIONESROL.OpcionMenuID
			INNER JOIN ',Par_PrincipalBD,'.OPCIONESROL	ON ',Par_MicroBD,'.OPCIONESROL.OpcionMenuID = ',Par_PrincipalBD,'.OPCIONESROL.OpcionMenuID
			WHERE ',Par_MicroBD,'.GRUPOSMENU.GrupoMenuID = ',Par_OpcionMenuID,';');

		SET @Sentencia := Var_Sentencia;
		PREPARE ELIMINAOPCIONESROL FROM @Sentencia;
		EXECUTE ELIMINAOPCIONESROL;
		SET FOREIGN_KEY_CHECKS=1;

		SET Par_NumErr		:=	2;
		SET Par_ErrMen		:=	'GRUPOSMENU ha sido eliminado con exito';
		SET Var_Control		:= 'GrupoMenuID';
		LEAVE ManejoErrores;

	END IF;


	IF(Par_NumCon = Opciones_Menu) THEN
		SET FOREIGN_KEY_CHECKS=0;

		SET Var_Sentencia	:=	CONCAT('
			DELETE ',Par_MicroBD,'.OPCIONESMENU, 	',Par_MicroBD,'.OPCIONESROL,  ',Par_PrincipalBD,'.OPCIONESROL
			FROM 	   ',Par_MicroBD,'.MENUSAPLICACION
			INNER JOIN ',Par_MicroBD,'.GRUPOSMENU 			ON ',Par_MicroBD,'.MENUSAPLICACION.MenuID = ',Par_MicroBD,'.GRUPOSMENU.MenuID
			INNER JOIN ',Par_MicroBD,'.OPCIONESMENU 		ON ',Par_MicroBD,'.GRUPOSMENU.GrupoMenuID = ',Par_MicroBD,'.OPCIONESMENU.GrupoMenuID
			INNER JOIN ',Par_MicroBD,'.OPCIONESROL			ON ',Par_MicroBD,'.OPCIONESMENU.OpcionMenuID = ',Par_MicroBD,'.OPCIONESROL.OpcionMenuID
			INNER JOIN ',Par_PrincipalBD,'.OPCIONESROL	ON ',Par_MicroBD,'.OPCIONESROL.OpcionMenuID = ',Par_PrincipalBD,'.OPCIONESROL.OpcionMenuID
			WHERE ',Par_MicroBD,'.OPCIONESMENU.OpcionMenuID = ',Par_OpcionMenuID,';');

		SET @Sentencia := Var_Sentencia;
		PREPARE ELIMINAOPCIONESROL FROM @Sentencia;
		EXECUTE ELIMINAOPCIONESROL;
		SET FOREIGN_KEY_CHECKS=1;

		SET Par_NumErr		:=	3;
		SET Par_ErrMen		:=	'OPCIONESMENU ha sido eliminado con exito';
		SET Var_Control		:= 'OpcionMenuID';
		LEAVE ManejoErrores;
	END IF;

 END ManejoErrores;


	IF (Par_Salida = Con_SalidaSI) THEN
		SELECT 	Par_NumErr 		AS NumErr,
				Par_ErrMen 		AS ErrMen,
				Var_Control 	AS Control,
                Entero_Cero		AS Consecutivo;
    END IF;

END TerminaStore$$
