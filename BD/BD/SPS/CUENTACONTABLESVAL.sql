-- SP CUENTACONTABLESVAL

DELIMITER ;
DROP PROCEDURE IF EXISTS CUENTASCONTABLESVAL;

DELIMITER $$
CREATE PROCEDURE `CUENTASCONTABLESVAL`(
    Par_CuentaCompleta  CHAR(25),

    Par_Salida          CHAR(1),

    INOUT Par_NumErr 	INT(11),			-- INOUT Numero de Error.
	INOUT Par_ErrMen  	VARCHAR(400),		-- INOUT Mensaje de Error.

    Par_EmpresaID		INT(11),	    -- Parametro de Auditoria Par_EmpresaID.
	Aud_Usuario			INT(11),	    -- Parametro de Auditoria Aud_Usuario.
	Aud_FechaActual		DATETIME,	    -- Parametro de Auditoria Aud_FechaActual.
	Aud_DireccionIP		VARCHAR(15),    -- Parametro de Auditoria Aud_DireccionIP.
	Aud_ProgramaID		VARCHAR(50),    -- Parametro de Auditoria Aud_ProgramaID.
	Aud_Sucursal		INT(11),	    -- Parametro de Auditoria Aud_Sucursal.
	Aud_NumTransaccion  BIGINT(20)	    -- Parametro de Auditoria Aud_NumTransaccion.
) 
TerminaStore : BEGIN
    -- Declaracion de Constantes.
    DECLARE	EnteroCero		INT(1);
    DECLARE CadenaVacia		CHAR(1);
    DECLARE Salida_SI       CHAR(1);

    -- Declaracion de Variables.
    DECLARE Var_Detalle     CHAR(1);
    DECLARE Var_TipoGrupo   CHAR(1);
    

	-- Asignacion de Contantes.
	SET EnteroCero			:=	0;						-- Constante Entero Cero.
	SET CadenaVacia			:=	'';	                    -- Contante Cadena Vacia.
    SET Salida_SI           :=  'S';					

    -- Asignacion de Variables.
    SET Var_Detalle     :=  'D';

    ManejoErrores : BEGIN

        IF NOT EXISTS(  SELECT  CuentaCompleta
			            FROM    CUENTASCONTABLES
			            WHERE   CuentaCompleta	= Par_CuentaCompleta) THEN

            SET Par_NumErr := 001;
			SET Par_ErrMen := 'La Cuenta Contable No Existe.';
			LEAVE ManejoErrores;
		END IF;

        SELECT  Grupo
        INTO    Var_TipoGrupo
        FROM    CUENTASCONTABLES
        WHERE   CuentaCompleta = Par_CuentaCompleta;

        IF( Var_TipoGrupo <> Var_Detalle) THEN

            SET Par_NumErr := 002;
			SET Par_ErrMen := concat('La Cuenta Contable: ',Par_CuentaCompleta, ' es de ENCABEZADO');
			LEAVE ManejoErrores;
        END IF;

    SET Par_NumErr := 000;
	SET Par_ErrMen := concat('La Cuenta Contable: ',Par_CuentaCompleta, ' es de Detalle');

    END ManejoErrores;

    IF( Par_Salida = Salida_SI) THEN
        SELECT  Par_NumErr  AS  NumErr,
            Par_ErrMen  AS  ErrMen;
    END IF;

END TerminaStore$$