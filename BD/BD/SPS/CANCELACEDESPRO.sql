-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CANCELACEDESPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CANCELACEDESPRO`;DELIMITER $$

CREATE PROCEDURE `CANCELACEDESPRO`(
# ======================================================================================
# ----PROCESO QUE CANCELA TODAS LAS CEDES QUE SE DIERON DE ALTA HOY Y QUE NO FUERON-----
# -------------AUTORIZADAS O CANCELADAS. SOLO CAMBIA ESTATUS A "C-CANCELADO"------------
# ======================================================================================
    Par_FechaOperacion      DATE,               -- Fecha de Operacion

    Par_Salida              CHAR(1),            -- Indica una salida
    INOUT Par_NumErr        INT(11),            -- Numero de Error
    INOUT Par_ErrMen        VARCHAR(400),       -- Mensaje de error

    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),            -- ID del Usuario
    Aud_FechaActual         DATETIME,           -- Fecha Actual
    Aud_DireccionIP         VARCHAR(15),        -- Direccion ID
    Aud_ProgramaID          VARCHAR(50),        -- Programa ID
    Aud_Sucursal            INT(11),            -- Sucursal
    Aud_NumTransaccion      BIGINT(20)          -- Numero de Transaccion
)
TerminaStore: BEGIN

	-- Delaracion de Constantes
	DECLARE Salida_SI		CHAR(1);
	DECLARE Salida_NO       CHAR(1);
	DECLARE CancAut         VARCHAR(50);
	DECLARE Estatus_Can     CHAR(1);
	DECLARE Estatus_Alt     CHAR(1);

	-- Asignacion de Constantes
	SET Salida_SI           := 'S';                      -- Salida en Pantalla SI
	SET Salida_NO           := 'N';                      -- Salida en Pantalla NO
	SET CancAut             := 'CANCELACEDESPRO';        -- Cancelacion Automatica
	SET Estatus_Can         := 'C';                      -- Estatus Cancelada
	SET Estatus_Alt         := 'A';                      -- Estatus Alta

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion.Disculpe las molestias que',
										'esto le ocasiona. Ref: SP-CANCELACEDESPRO');
			END;

		UPDATE CEDES SET
				Estatus         = Estatus_Can,
				EmpresaID       = Par_EmpresaID,
				UsuarioID       = Aud_Usuario,
				FechaActual     = Aud_FechaActual,
				DireccionIP     = Aud_DireccionIP,
				ProgramaID      = CancAut,
				Sucursal        = Aud_Sucursal,
				NumTransaccion  = Aud_NumTransaccion
		WHERE   FechaInicio 	= Par_FechaOperacion
		AND 	Estatus			= Estatus_Alt;

		SET Par_NumErr := 0;
		SET Par_ErrMen := 'CEDES Cancelados Exitosamente.';

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen;
	END IF;

END TerminaStore$$