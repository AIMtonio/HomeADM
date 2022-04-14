-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAPARAMSPREMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAPARAMSPREMOD`;
DELIMITER $$

CREATE PROCEDURE `EDOCTAPARAMSPREMOD`(
	-- SP para Parametrizar el Estado de Cuenta
	Par_Prefijo			    VARCHAR(100),		-- Prefijo de la Empresa en cuestion

	Par_Salida				CHAR(1),			-- Descripcion de Salida
	INOUT Par_NumErr		INT(11),			-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),		-- Descripcion del Error

	-- Parametros de Auditoria
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT,
	Aud_FechaActual			DATE,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT

)

TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control			VARCHAR(50);	-- Control de Errores
	DECLARE	Var_NumInstitucion  INT;			-- Numero de Institucion de la tabla PARAMETROSSIS

	DECLARE Cadena_Vacia	CHAR;				-- Cadena Vacia
	DECLARE Entero_Cero		INT;				-- Entero Cero
	DECLARE SalidaSI		CHAR(1);			-- Tipo Salida: SI

	SET Cadena_Vacia		:='';		-- Cadena Vacia
	SET Entero_Cero			:= 0;		-- Entero Cero
	SET SalidaSI			:='S';		-- Tipo Salida: SI

	ManejoErrores: BEGIN

        -- Se valida que el prefijo pasado no este vació
        IF ( IFNULL( Par_Prefijo, Cadena_Vacia ) = Cadena_Vacia ) THEN
            SET Par_NumErr := 1;
            SET Par_ErrMen := "El Prefijo no debe de estar vacio";
            SET Var_Control	:='prefijo';
            LEAVE ManejoErrores;
        END IF;

        -- Se obtiene el Numero de Institucion de la tabla PARAMETROSSIS
        SET	Var_NumInstitucion	:= (SELECT InstitucionID FROM PARAMETROSSIS);

        -- Se obtiene la Fecha Actual
        SET Aud_FechaActual := NOW();

        -- Se actualiza la parametrizacion del estado de cuenta
        SET Aud_FechaActual := CURRENT_TIMESTAMP();

        UPDATE EDOCTAPARAMS SET
            PrefijoEmpresa		    = Par_Prefijo,

            EmpresaID				= Par_EmpresaID,
            Usuario					= Aud_Usuario,
            FechaActual				= Aud_FechaActual,
            DireccionIP				= Aud_DireccionIP,
            ProgramaID				= Aud_ProgramaID,
            Sucursal				= Aud_Sucursal,
            NumTransaccion			= Aud_NumTransaccion
        WHERE InstitucionID = Var_NumInstitucion;

        SET Par_NumErr := 0;
        SET Par_ErrMen := CONCAT("Prefijo Modificado Correctamente");
        SET Var_Control	:='prefijoEdoCta';

	END ManejoErrores;

    IF (Par_Salida = SalidaSI) THEN
            SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control;
    END IF;

END TerminaStore$$