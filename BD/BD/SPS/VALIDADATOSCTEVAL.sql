DELIMITER ;
DROP PROCEDURE IF EXISTS `VALIDADATOSCTEVAL`;
DELIMITER $$

CREATE PROCEDURE `VALIDADATOSCTEVAL`(
/* ========== SP PARA MODIFICACION DE CLIENTES ============== */
	Par_ClienteID           INT(11),          -- ID del Cliente
	Par_Salida              CHAR(1),          -- Tipo salida

	INOUT Par_NumErr        INT(11),          -- Numero de error
	INOUT Par_ErrMen        VARCHAR(400),     -- Mensaje de error
	/* Parametros de Auditoria */
	Par_EmpresaID           INT(11),
	Aud_Usuario             INT(11),
	Aud_FechaActual         DATETIME,
	Aud_DireccionIP         VARCHAR(15),
	Aud_ProgramaID          VARCHAR(50),
	Aud_Sucursal            INT(11),
	Aud_NumTransaccion      BIGINT(20)
)
TerminaStore: BEGIN

	DECLARE Var_NumErr        INT(11);
	DECLARE Var_ErrMen        VARCHAR(350);
	DECLARE Var_Estatus       CHAR(1);
	DECLARE Var_Control       VARCHAR(200);
	DECLARE Var_Consecutivo   INT(11);
	DECLARE Var_RolUsuario   INT(11);

	-- Declaracion de Constantes
	DECLARE Inactivo          CHAR(1);
    DECLARE Entero_Cero       INT;
    DECLARE Sol_Inactivos      INT;
    DECLARE Str_SI            CHAR(1);
	DECLARE Str_NO            CHAR(1);

	-- Asigancion de Constantes
	SET Inactivo            :='I';    -- Estatus incativo de socio
    SET Entero_Cero         := 0;
    SET Str_SI              :='S';    -- Constante SI
	SET Str_NO              :='N';    -- Constante NO

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  := 999;
			SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-VALIDADATOSCTEVAL');
			SET Var_Control := 'sqlException';
		END;


        SELECT RolID INTO Var_RolUsuario
			FROM USUARIOS
			WHERE UsuarioID = Aud_Usuario
				AND RolID NOT IN (SELECT RolID FROM PERFILESANALISTAS WHERE TipoPerfil = 'E');

        SET Var_RolUsuario:= IFNULL(Var_RolUsuario,Entero_Cero);

		IF(Var_RolUsuario != Entero_Cero)THEN


			SET Sol_Inactivos:=(SELECT COUNT(CR.Estatus)
					FROM SOLICITUDCREDITO CR
					INNER JOIN CLIENTES CL ON CR.ClienteID=CL.ClienteID
					WHERE CR.ClienteID=Par_ClienteID and CR.Estatus=Inactivo );

			SET Sol_Inactivos:= IFNULL(Sol_Inactivos,Entero_Cero);


			IF(Sol_Inactivos=Entero_Cero)THEN
				SET Par_NumErr  := 1;
				SET Par_ErrMen  := 'No se puede modificar la información por políticas internas.';
				SET Var_Control := 'clienteID';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

        ELSE
			SET Sol_Inactivos:=(SELECT COUNT(CR.Estatus)
					FROM SOLICITUDCREDITO CR
					INNER JOIN CLIENTES CL ON CR.ClienteID=CL.ClienteID
					WHERE CR.ClienteID=Par_ClienteID and CR.Estatus='L');

			SET Sol_Inactivos:= IFNULL(Sol_Inactivos,Entero_Cero);

            IF(Sol_Inactivos!=Entero_Cero)THEN
				SET Par_NumErr  := 1;
				SET Par_ErrMen  := 'No se puede modificar la información por políticas internas.';
				SET Var_Control := 'clienteID';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

        END IF;

			SET Par_NumErr  := 0;
			SET Par_ErrMen  := 'El ciente si puede modificar su informacion';
			SET Var_Control := 'clienteID';
			SET Var_Consecutivo := Entero_Cero;

	END ManejoErrores;

IF (Par_Salida = Str_SI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Var_Consecutivo AS Consecutivo;
END IF;

END TerminaStore$$