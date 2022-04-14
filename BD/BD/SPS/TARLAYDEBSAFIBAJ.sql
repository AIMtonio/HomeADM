
-- TARLAYDEBSAFIBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARLAYDEBSAFIBAJ`;
DELIMITER $$

CREATE PROCEDURE `TARLAYDEBSAFIBAJ`(

	Par_LoteDebSAFIID       INT(11),
	Par_TipoBaja			TINYINT UNSIGNED,
	Par_Salida          	CHAR(1),
	INOUT Par_NumErr    	INT(11),

    INOUT Par_ErrMen   		VARCHAR(400),
	Par_EmpresaID       	INT(11),
    Aud_Usuario         	INT(11),
    Aud_FechaActual     	DATETIME,
    Aud_DireccionIP     	VARCHAR(15),

    Aud_ProgramaID      	VARCHAR(50),
    Aud_Sucursal        	INT(11),
	Aud_NumTransaccion  	BIGINT(20)

	)
TerminaStore:BEGIN

-- variable
DECLARE Var_Control		VARCHAR(50);
DECLARE Var_NumTransaccion  BIGINT(20);
DECLARE Var_CantTar         INT(11);

-- constantes
DECLARE BajaRegistro		INT(11);
DECLARE Cadena_Vacia		CHAR(1);
DECLARE Entero_Cero			INT(11);
DECLARE SalidaSI			CHAR(1);


SET BajaRegistro			:= 1;
SET Cadena_Vacia			:= '';
SET Entero_Cero				:= 0;
SET SalidaSI				:= 'S';

ManejoErrores: BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
          SET Par_NumErr = 999;
          SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
                          concretar la operacion.Disculpe las molestias que', 'esto le ocasiona. Ref: SP-TARLAYDEBSAFIBAJ');
          SET Var_Control = 'sqlException';
        END;

	IF (Par_TipoBaja=BajaRegistro)THEN

		IF (Par_LoteDebSAFIID=Entero_Cero)THEN
				SET Par_NumErr  :=  001;
				SET Par_ErrMen  :=  'No existe el Lote de Tarjetas SAFI';
				SET Var_Control :=  'habilitadoSAFI';
				LEAVE ManejoErrores;
		END IF;

        -- SE TIENE LA CANTIDAD DE REGISTROS
        SELECT COUNT(LoteDebSAFIID)
            INTO Var_CantTar
        FROM TARLAYDEBSAFI
            WHERE LoteDebSAFIID = Par_LoteDebSAFIID;

        -- SE ACTUALIZA EL VALOR
        UPDATE FOLIOSTARJETA SET FolioTarjetaID = FolioTarjetaID - Var_CantTar;

        -- ELIMINAN LOS REGISTROS EN BITACORA
        DELETE FROM BITACORATARJETA
            WHERE NumTarjeta IN (SELECT NumTarjeta
                                    FROM TARLAYDEBSAFI
                                        WHERE LoteDebSAFIID = Par_LoteDebSAFIID);

        -- obtiene el número de transacción
        SELECT NumTransaccion
            INTO Var_NumTransaccion
        FROM TARLAYDEBSAFI
            WHERE LoteDebSAFIID = Par_LoteDebSAFIID limit 1;
        -- Se elimina la información registrada de la TARJETADEBITO
        DELETE FROM TARJETADEBITO WHERE NumTransaccion = Var_NumTransaccion;
        -- Se elimina la información registra de la tabla TARLAYDEBSAFI
		DELETE FROM `TARLAYDEBSAFI` WHERE LoteDebSAFIID = Par_LoteDebSAFIID;

		SET Par_NumErr := 002;
        SET Par_ErrMen := CONCAT('Ha ocurrido un Error. No se pudieron insertar los registros.');
        SET Var_Control :=  'habilitadoSAFI';
        LEAVE ManejoErrores;

	END IF;

END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
            SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
                    Par_ErrMen AS ErrMen,
                    Var_Control AS control,
                    Entero_Cero AS consecutivo;
    END IF;


END TerminaStore$$
