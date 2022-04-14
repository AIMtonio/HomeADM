-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BALANZASDENOMACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BALANZASDENOMACT`;DELIMITER $$

CREATE PROCEDURE `BALANZASDENOMACT`(



    Par_SucursalID		INT(11),
    Par_CajaID          INT(11),
    Par_DenomID         INT(11),
    Par_MonedaID        INT(11),
    Par_Cantidad        DECIMAL(14,2),

    Par_Naturaleza      INT,
    Par_NumAct          TINYINT UNSIGNED,

    Par_Salida          CHAR(1),
    INOUT Par_NumErr    INT(11),
    INOUT Par_ErrMen    VARCHAR(400),

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT
		)
TerminaStore: BEGIN


    DECLARE Var_SucursalID      INT;
    DECLARE Var_SucursalCaja    INT;
    DECLARE Var_Control         VARCHAR(100);


    DECLARE Cadena_Vacia        CHAR(1);
    DECLARE Fecha_Vacia         DATE;
    DECLARE Entero_Cero         INT;
    DECLARE Act_Saldo           INT;
    DECLARE Mov_Entrada         INT;
    DECLARE Mov_Salida          INT;
    DECLARE Salida_SI           CHAR(1);


    SET Cadena_Vacia    := '';
    SET Fecha_Vacia     := '1900-01-01';
    SET Entero_Cero     := 0;
    SET Act_Saldo       := 1;
    SET Mov_Entrada     := 1;
    SET Mov_Salida      := 2;
    SET Salida_SI       := 'S';

    SET Aud_FechaActual := now();

    ManejoErrores:BEGIN

        DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-BALANZASDENOMACT');
				SET Var_Control = 'sqlException';
			END;

		IF(Par_NumAct = Act_Saldo) THEN
			IF (Par_Naturaleza = Mov_Salida) THEN
				SET Par_Cantidad := Par_Cantidad*-1;
			END IF;

			SELECT	SucursalID INTO Var_SucursalID
				FROM BALANZADENOM Bal
				WHERE	SucursalID       = Par_SucursalID
				  AND	CajaID           = Par_CajaID
				  AND	DenominacionID   = Par_DenomID
				  AND	MonedaID         = Par_MonedaID;

			IF(IFNULL(Var_SucursalID, Entero_Cero) = Entero_Cero) THEN
				INSERT	BALANZADENOM VALUES(
					Par_SucursalID,		Par_CajaID,		Par_DenomID,        Par_MonedaID,       Par_Cantidad,
					Par_EmpresaID,      Aud_Usuario,   	Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
					Aud_Sucursal,       Aud_NumTransaccion);
			ELSE
				UPDATE	BALANZADENOM SET
					Cantidad    = Cantidad + Par_Cantidad
					WHERE	SucursalID        = Par_SucursalID
					  AND	CajaID            = Par_CajaID
					  AND	DenominacionID    = Par_DenomID
					  AND	MonedaID          = Par_MonedaID;
			END IF;

			SET	Par_NumErr 	:= 000;
			SET	Par_ErrMen 	:= 'Movimiento Realizado Correctamente.';

		END IF;

	END ManejoErrores;

        IF (Par_Salida = Salida_SI) THEN
            SELECT  Par_NumErr	AS NumErr,
                    Par_ErrMen  AS ErrMen,
                    Var_Control AS control;
        END IF;

END TerminaStore$$