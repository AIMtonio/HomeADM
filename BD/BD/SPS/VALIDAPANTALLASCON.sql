-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- VALIDAPANTALLASCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `VALIDAPANTALLASCON`;DELIMITER $$

CREATE PROCEDURE `VALIDAPANTALLASCON`(
	Par_ClaveUsuario 	VARCHAR(100),
	Par_NumCon			TINYINT UNSIGNED

)
BEGIN

DECLARE	Con_PorPerfil 	INT;
DECLARE Var_Rol        	INT;


SET Con_PorPerfil= 1;

	SELECT 	RolID
		INTO Var_Rol
		FROM USUARIOS
		WHERE Clave = Par_ClaveUsuario;

IF(Par_NumCon = Con_PorPerfil) THEN

	SELECT 		CASE Me.Desplegado
					WHEN 'safilocale.cliente' THEN 'Cliente'
                    WHEN 'safilocale.cuentascte' THEN 'Cuentas Cliente'
                    ELSE Me.Desplegado
                    END AS Menu,			Gr.Desplegado AS Grupo,
				Op.Desplegado AS Pantalla
			FROM  	OPCIONESMENU 	Op,
					GRUPOSMENU	  	Gr,
					MENUSAPLICACION	Me,
					OPCIONESROL     opRol
			WHERE opRol.RolID 		= Var_Rol
			  AND Op.OpcionMenuID 	= opRol.OpcionMenuID
			  AND Op.GrupoMenuID	= Gr.GrupoMenuID
			  AND Gr.MenuID 		= Me.MenuID

			ORDER BY Me.Orden, Gr.Orden, Op.Orden;

END IF;

END$$