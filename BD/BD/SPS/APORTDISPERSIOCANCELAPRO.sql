

-- APORTDISPERSIOCANCELAPRO --

DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTDISPERSIOCANCELAPRO`;
-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE PROCEDURE `APORTDISPERSIOCANCELAPRO`(
/* CANCELACIÓN DE DISPERSIONES DE APORTACIONES PENDIENTES. */
	Par_FechaOperacion      DATE,
	Par_Salida              CHAR(1),
	INOUT Par_NumErr        INT(11),
	INOUT Par_ErrMen        VARCHAR(400),

	Par_EmpresaID           INT(11),

	Aud_Usuario             INT(11),
	Aud_FechaActual         DATETIME,
	Aud_DireccionIP         VARCHAR(15),
	Aud_ProgramaID          VARCHAR(50),
	Aud_Sucursal            INT(11),

	Aud_NumTransaccion      BIGINT(20)
)
TerminaStore: BEGIN


	DECLARE Salida_SI		CHAR(1);
	DECLARE Salida_NO		CHAR(1);
	DECLARE Estatus_Pag		CHAR(1);
	DECLARE Estatus_Canc	CHAR(1);

	DECLARE Var_Aux			 	 INT(11);
	DECLARE Var_AportacionID	 INT(11);
	DECLARE Var_AmortizacionID   INT(11);
	DECLARE	Var_FechaSistema	 DATE;
	DECLARE Fecha_Vacia			 DATE;
	DECLARE Var_FechaVencimiento DATE;
	DECLARE Var_FechaProxPago	 DATE;
	DECLARE Var_EstatusVigente   CHAR(1);
	DECLARE Entero_Uno			 INT(11);
	DECLARE Fecha_Habil			 DATE;
	DECLARE Var_EsHabil			 CHAR(1);

	SET Salida_SI			:= 'S';
	SET Salida_NO			:= 'N';
	SET Estatus_Canc		:= 'C';
	SET Estatus_Pag			:= 'P';				-- Estatus Pagada.
	SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia.
	SET Var_EstatusVigente	:= 'N';
	SET Entero_Uno			:= 1;


	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-APORTDISPERSIOCANCELAPRO.');
			END;

		SET Var_FechaSistema := Par_FechaOperacion;
		SET Var_FechaSistema := IFNULL(Var_FechaSistema, Fecha_Vacia);
		
		CALL DIASFESTIVOSCAL(   Var_FechaSistema,    Entero_Uno,         Fecha_Habil,        Var_EsHabil,       Par_EmpresaID,
                                Aud_Usuario,   		 Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,    Aud_Sucursal,
                                Aud_NumTransaccion);

		SET Var_FechaProxPago := (SELECT MIN(FechaPago) FROM AMORTIZAAPORT
									WHERE FechaPago >= Var_FechaSistema
										AND Estatus IN (Var_EstatusVigente,Estatus_Pag));

		IF(Var_FechaSistema  <= Var_FechaProxPago AND Var_FechaProxPago < Fecha_Habil)THEN

			INSERT IGNORE INTO HISAPORTDISPERSIONES(
				AportacionID,		AmortizacionID,		ClienteID,			CuentaAhoID,		Capital,
				Interes,			InteresRetener,		Total,				Estatus,			FechaVencimiento,
				FechaDispersion,	EmpresaID,			UsuarioID,			FechaActual,		DireccionIP,
				ProgramaID,			Sucursal,			NumTransaccion)
			SELECT
				AportacionID,		AmortizacionID,		ClienteID,			CuentaAhoID,		Capital,
				Interes,			InteresRetener,		Total,				Estatus_Canc,		FechaVencimiento,
				Var_FechaSistema,	Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
			FROM APORTDISPERSIONES
			WHERE FechaVencimiento < Var_FechaSistema;

			DELETE FROM  APORTCTADISPERSIONES
			WHERE FechaVencimiento < Var_FechaSistema;

			DELETE AB
			FROM APORTBENEFICIARIOS AB
				INNER JOIN APORTDISPERSIONES AD ON AB.AportacionID = AD.AportacionID
			AND AB.AmortizacionID = AD.AmortizacionID;

			DELETE FROM APORTDISPERSIONES
			WHERE FechaVencimiento < Var_FechaSistema;

			-- Actualizar la fecha en la que se ejecuta la operacion 
			UPDATE PARAMGENERALES
				SET ValorParametro = Par_FechaOperacion
				WHERE 	LlaveParametro = 'FechaUltEjecAport';

		END IF;

		SET Par_NumErr := 0;
		SET Par_ErrMen := 'Aportaciones Canceladas Exitosamente.';

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen;
	END IF;

END TerminaStore$$

DELIMITER ;