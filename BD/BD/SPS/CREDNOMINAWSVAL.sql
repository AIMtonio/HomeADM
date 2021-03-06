-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDNOMINAWSVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDNOMINAWSVAL`;
DELIMITER $$

CREATE PROCEDURE `CREDNOMINAWSVAL`(
	-- Store Procedure Exclusivo de WS para vaildar los datos requeridos para consulta de los Creditos de Nomina.
	Par_InstitucionID		INT(11),		-- Indica el numero de Institucion de Nomina
    Par_Estatus             CHAR(1),        -- Indica el Estatus del Credto V=Vigente B=Vencido
    Par_EstatusInstal       CHAR(1),        -- Indica el Estatus de la Instalacion I=Instalado N=No Instalado

	Par_Salida				CHAR(1),		-- Paramentro de Salida
	INOUT Par_NumErr		INT(11),		-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de Error

	Par_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE	Var_Control				VARCHAR(15);	    -- Control a retornar en pantalla
    DECLARE Var_Institucion         INT(11);            -- ID de Institucion de Nomina
	-- Declaracion de Constantes,
	DECLARE	Entero_Cero				INT(11);			-- Constante de entero cero
	DECLARE	Cadena_Vacia			CHAR(1);			-- Constante cadena vacia
	DECLARE	SalidaSI				CHAR(1);			-- Salida Si
	DECLARE Con_Vigente             CHAR(1);            -- Estatus Vigente 'V'
    DECLARE Con_Vencido             CHAR(1);            -- Estatus Vencido 'B'
    DECLARE Con_Instalado           CHAR(1);            -- Estatus Instalado 'I'
    DECLARE Con_NoInstalado         CHAR(1);            -- Estatus No Instalado 'N'
	DECLARE Con_Pagado              CHAR(1);            -- Estatus Pagado  'P'

	-- Asignacion de Constantes
	SET Entero_Cero					:= 0;
	SET Cadena_Vacia				:='';
	SET SalidaSI					:= 'S';
    SET Con_Vigente					:= 'V';
	SET Con_Vencido					:= 'B';
	SET Con_Instalado				:= 'I';
	SET Con_NoInstalado				:= 'N';
	SET Con_Pagado                  := 'P';


	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que  ',
									 'esto le ocasiona. Ref: SP-CREDNOMINAWSVAL');
			SET Var_Control = 'sqlException';
		END;

		-- Valida la Instituci??n
		IF(IFNULL(Par_InstitucionID, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := 001;
			SET Par_ErrMen  := 'El Numero de Institucion esta Vacio.';
			SET Var_Control := Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

        SET Var_Institucion := (SELECT InstitNominaID FROM INSTITNOMINA WHERE InstitNominaID = Par_InstitucionID);
        SET Var_Institucion := IFNULL(Var_Institucion, Entero_Cero);

		IF(Var_Institucion = Entero_Cero) THEN
			SET Par_NumErr  := 002;
			SET Par_ErrMen  := 'La Institucion No Existe';
			SET Var_Control := Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

        -- Valida el Estatus del Cr??dito de Nomina
        IF(IFNULL(Par_Estatus, Cadena_Vacia)) != Cadena_Vacia THEN
            IF(Par_Estatus NOT IN (Con_Vigente, Con_Vencido,Con_Pagado))THEN
                SET Par_NumErr  := 003;
                SET Par_ErrMen  := 'El Estatus para los Creditos es Incorrecto';
                SET Var_Control := Cadena_Vacia;
                LEAVE ManejoErrores;
            END IF;
		END IF;

        IF(IFNULL(Par_EstatusInstal, Cadena_Vacia)) = Cadena_Vacia THEN
            SET Par_NumErr  := 004;
            SET Par_ErrMen  := 'El Estatus de Instalacion esta Vacio';
            SET Var_Control := Cadena_Vacia;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_EstatusInstal, Cadena_Vacia)) NOT IN (Con_Instalado, Con_NoInstalado) THEN
            SET Par_NumErr  := 005;
            SET Par_ErrMen  := 'El Estatus de Instalacion no Existe';
            SET Var_Control := Cadena_Vacia;
            LEAVE ManejoErrores;
        END IF;

        SET Par_NumErr  := Entero_Cero;
		SET Par_ErrMen  := 'Consulta realizada con exito';
		SET Var_Control := Cadena_Vacia;

	END ManejoErrores;

	IF(Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control;
	END IF;

END TerminaStore$$