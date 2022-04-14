-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FOLIOACTACOMITEALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `FOLIOACTACOMITEALT`;
DELIMITER $$


CREATE PROCEDURE `FOLIOACTACOMITEALT`(


    Par_TipoActa		CHAR(1),
    Par_Fecha       	DATE,
    Par_SucursalID		INT(11),
    Par_Salida			CHAR(1),
	OUT	Par_Folio	   	BIGINT,
    INOUT Par_NumErr 	INT (11),
   	INOUT Par_ErrMen  	VARCHAR(350),

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT

		)

TerminaStore: BEGIN


DECLARE Var_NumSolici   INT(11);
DECLARE Var_Control	   	VARCHAR(200);
DECLARE Var_Consecutivo INT(11);

DECLARE Cadena_Vacia    CHAR(1);
DECLARE Entero_Cero     INT(11);
DECLARE Monto_Mayores   DECIMAL(12,2);
DECLARE Sta_Autorizada  CHAR(1);
DECLARE Sta_Desembol    CHAR(1);
DECLARE Sta_Inactivo    CHAR(1);
DECLARE Sta_Cancelado   CHAR(1);
DECLARE Rel_Empleado    INT(11);
DECLARE Salida_SI       CHAR(1);
DECLARE Acta_Sucursal   CHAR(1);
DECLARE Acta_CreMayores CHAR(1);
DECLARE Acta_Relaciona  CHAR(1);
DECLARE Acta_Reestruc   CHAR(1);



SET Cadena_Vacia    := '';
SET Entero_Cero     := 0;
SET Monto_Mayores   := 60000;
SET Sta_Autorizada  := 'A';
SET Sta_Desembol    := 'D';
SET Sta_Inactivo    := 'I';
SET Sta_Cancelado   := 'C';
SET Rel_Empleado    := 2;
SET Salida_SI       := 'S';
SET Acta_Sucursal   := 'S';
SET Acta_CreMayores := 'C';
SET Acta_Relaciona  := 'L';
SET Acta_Reestruc   := 'R';


SET Par_Folio  		:= Entero_Cero;
SET Aud_FechaActual := NOW();
SET Par_EmpresaID   := 1;
SET Aud_Usuario     := 1;
SET Aud_DireccionIP := '127.0.0.1';
SET Aud_ProgramaID  := 'FOLIOACTACOMITEALT';
SET Aud_Sucursal    := 1;
SET Aud_NumTransaccion   := 1;


		ManejoErrores:BEGIN
			DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					SET Par_NumErr	= 999;
					SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
											'esto le ocasiona. Ref: SP-FOLIOACTACOMITEALT');
					SET Var_Control = 'sqlException';
		END;



IF(Par_TipoActa = Acta_Sucursal) THEN

	 SELECT MAX(FolioID) INTO Par_Folio
            FROM FOLIOSACTASCOMITE
            WHERE TipoActa = Acta_Sucursal
              AND SucursalID = Par_SucursalID
              AND Fecha = Par_Fecha;

        SET Par_Folio := IFNULL(Par_Folio, Entero_Cero);

        IF(Par_Folio = Entero_Cero) THEN

            SELECT MAX(FolioID) INTO Par_Folio
                FROM FOLIOSACTASCOMITE
                WHERE TipoActa = Acta_Sucursal
                  AND SucursalID = Par_SucursalID;

            SET Par_Folio := IFNULL(Par_Folio, 0);
            SET Par_Folio := Par_Folio + 1;

            INSERT INTO FOLIOSACTASCOMITE	(
						FolioID,					TipoActa,					SucursalID,					Fecha,					EmpresaID,
						Usuario,					FechaActual,				DireccionIP,					ProgramaID,				Sucursal,
						NumTransaccion)
			VALUES (
						Par_Folio,      Acta_Sucursal,  Par_SucursalID,     Par_Fecha,
						Par_EmpresaID,  Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,
						Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion  );
        END IF;

END IF;



IF(Par_TipoActa = Acta_CreMayores) THEN

	SELECT  MAX(FolioID) INTO Par_Folio
            FROM FOLIOSACTASCOMITE
            WHERE TipoActa = Acta_CreMayores
              AND Fecha = Par_Fecha;

        SET Par_Folio := IFNULL(Par_Folio, Entero_Cero);

        IF(Par_Folio = Entero_Cero) THEN

            SELECT MAX(FolioID) INTO Par_Folio
                FROM FOLIOSACTASCOMITE
                WHERE TipoActa = Acta_CreMayores;

            SET Par_Folio := IFNULL(Par_Folio, 0);
            SET Par_Folio := Par_Folio + 1;

            INSERT INTO FOLIOSACTASCOMITE	(
						FolioID,					TipoActa,					SucursalID,					Fecha,					EmpresaID,
						Usuario,					FechaActual,				DireccionIP,					ProgramaID,				Sucursal,
						NumTransaccion)
			VALUES (
						Par_Folio,      Acta_CreMayores,  Entero_Cero,       Par_Fecha,
						Par_EmpresaID,  Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,
						Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion  );
        END IF;

END IF;



IF(Par_TipoActa = Acta_Relaciona) THEN

	 SELECT  MAX(FolioID) INTO Par_Folio
            FROM FOLIOSACTASCOMITE
            WHERE TipoActa = Acta_Relaciona
              AND Fecha = Par_Fecha;

        SET Par_Folio := IFNULL(Par_Folio, Entero_Cero);

        IF(Par_Folio = Entero_Cero) THEN

            SELECT MAX(FolioID) INTO Par_Folio
                FROM FOLIOSACTASCOMITE
                WHERE TipoActa = Acta_Relaciona;

            SET Par_Folio := IFNULL(Par_Folio, 0);
            SET Par_Folio := Par_Folio + 1;

            INSERT INTO FOLIOSACTASCOMITE	(
						FolioID,					TipoActa,					SucursalID,					Fecha,					EmpresaID,
						Usuario,					FechaActual,				DireccionIP,					ProgramaID,				Sucursal,
						NumTransaccion)
			VALUES (
						Par_Folio,      Acta_Relaciona,  Entero_Cero,       Par_Fecha,
						Par_EmpresaID,  Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,
						Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion  );
        END IF;
END IF;




IF(Par_TipoActa = Acta_Reestruc) THEN

	 SELECT  MAX(FolioID) INTO Par_Folio
            FROM FOLIOSACTASCOMITE
            WHERE TipoActa = Acta_Reestruc
              AND Fecha = Par_Fecha;

        SET Par_Folio := IFNULL(Par_Folio, Entero_Cero);

        IF(Par_Folio = Entero_Cero) THEN

            SELECT MAX(FolioID) INTO Par_Folio
                FROM FOLIOSACTASCOMITE
                WHERE TipoActa = Acta_Reestruc;

            SET Par_Folio := IFNULL(Par_Folio, 0);
            SET Par_Folio := Par_Folio + 1;

            INSERT INTO FOLIOSACTASCOMITE	(
						FolioID,					TipoActa,					SucursalID,					Fecha,					EmpresaID,
						Usuario,					FechaActual,				DireccionIP,					ProgramaID,				Sucursal,
						NumTransaccion)
			VALUES (
						Par_Folio,      Acta_Reestruc,  Entero_Cero,       Par_Fecha,
						Par_EmpresaID,  Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,
						Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion  );
        END IF;
END IF;

		SET Par_NumErr 		:= '000';
		SET Par_ErrMen 		:= CONCAT('Folio Acta Comite  Agregada Exitosamente: ',CAST(Par_Folio AS CHAR) );
		SET Var_Consecutivo	:= Par_Folio;


	END ManejoErrores;

IF(Par_Salida = Salida_SI) THEN
    SELECT Par_Folio AS FolioID;
END IF;
END TerminaStore$$
