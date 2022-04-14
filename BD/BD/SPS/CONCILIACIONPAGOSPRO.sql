-- SP CONCILIACIONPAGOSPRO

DELIMITER ;

DROP PROCEDURE IF EXISTS CONCILIACIONPAGOSPRO;

DELIMITER $$

CREATE PROCEDURE `CONCILIACIONPAGOSPRO`(
	-- Store que realiza la conciliacion de pagos.
	Par_ClaveUsu		VARCHAR(50),		-- Parametro que indica la clave del usuario
	Par_FechaConcil		DATE,				-- Parametro de Fecha de conciliacion

	Par_Salida			CHAR(1),			-- Indica si espera un SELECT de salida
	INOUT Par_NumErr 	INT(11),			-- Numero de Error
	INOUT Par_ErrMen 	VARCHAR(400), 		-- Descripcion de Error

	Par_EmpresaID		INT(11),			-- Parametro de Auditoria
	Aud_Usuario			INT(11),			-- Parametro de Auditoria
	Aud_FechaActual		DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP		VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID		VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal		INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion	BIGINT(20)			-- Parametro de Auditoria
)
TerminaStore:BEGIN

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		VARCHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE Decimal_Cero		DECIMAL(12,2);
	DECLARE Salida_SI 			CHAR(1);
	DECLARE Str_SI 				CHAR(1);
	DECLARE	Cons_SI				CHAR(1);			-- Constante SI
	DECLARE	Cons_NO				CHAR(1);			-- Constante NO
	DECLARE Salida_NO 			CHAR(1);
	DECLARE	Sta_Activa			CHAR(1);					-- Estatus Activa

	-- Declaracion de Variables
	DECLARE Var_Control 		VARCHAR(100);
	DECLARE Aux_NumReg			INT(11);
	DECLARE Aux_Contador		INT(11);
	DECLARE Var_DispoID 		VARCHAR(100);
	DECLARE Var_ClaUsuario 		VARCHAR(100);
	DECLARE	OrigMov				CHAR(1);			-- Origen movil
	DECLARE	OrigSaf				CHAR(1);			-- Origen Safi
	DECLARE	Var_FechaSistema	DATE;
	DECLARE	Var_FechaBusqueda	DATE;

	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';				-- Cadena Vacia
	SET Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero			:= 0;				-- Entero Cero
	SET Decimal_Cero		:= 0.00; 			-- Decimal Cero
	SET Salida_SI			:= 'S'; 			-- Salida Store: SI
	SET Salida_NO 			:= 'N'; 			-- Salida Store: NO
	SET	Sta_Activa			:= 'A';				-- Estatus Activa
	SET Cons_SI				:= 'S';
	SET Cons_NO				:= 'N';
	SET OrigMov 			:= 'M';
	SET OrigSaf 			:= 'S';

	 ManejoErrores:BEGIN

      DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
		  SET Par_NumErr  = 999;
		  SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
					'Disculpe las molestias que esto le ocasiona. Ref: SP-CONCILIACIONPAGOSPRO');
		  SET Var_Control = 'SQLEXCEPTION';
		END;

		DROP TABLE IF EXISTS TMPUSUARIOAPP;
		CREATE TEMPORARY TABLE TMPUSUARIOAPP(
			RegistroID_PK bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
			RegistroID        BIGINT(20),
			UsuarioID         INT(11),
			Clave             VARCHAR(45),
			IMEI              VARCHAR(32),
			NumTransaccion    INT(15)
		);

		SET @NumeroRegistro := 0;

		SET Par_ClaveUsu 		:= IFNULL(Par_ClaveUsu, Cadena_Vacia);
		SET Par_FechaConcil		:= IFNULL(Par_FechaConcil, Fecha_Vacia);

		SELECT FechaSistema INTO Var_FechaSistema FROM PARAMETROSSIS LIMIT 1;

		IF(Par_ClaveUsu = Cadena_Vacia) THEN
			INSERT INTO TMPUSUARIOAPP (RegistroID,				UsuarioID,				Clave,				IMEI,				NumTransaccion)
			SELECT  @NumeroRegistro:=(@NumeroRegistro + 1) AS RegistroID,
					UsuarioID,
					Clave,
					IMEI,
					Aud_NumTransaccion AS NumTransaccion
			FROM USUARIOS
			WHERE Estatus = Sta_Activa AND UsaAplicacion = Cons_SI;
			

			SET Aux_NumReg := (SELECT COUNT(UsuarioID) FROM TMPUSUARIOAPP WHERE NumTransaccion = Aud_NumTransaccion);
			SET Aux_Contador := 0;

			IF(Par_FechaConcil = Fecha_Vacia) THEN
				SET Var_FechaBusqueda := Var_FechaSistema; 
			END IF;

			IF(Par_FechaConcil <> Fecha_Vacia) THEN
				SET Var_FechaBusqueda := Par_FechaConcil; 
			END IF;		

			WHILE Aux_Contador < Aux_NumReg do
				SELECT Clave INTO Var_ClaUsuario FROM TMPUSUARIOAPP WHERE NumTransaccion = Aud_NumTransaccion LIMIT Aux_Contador, 1;

				DELETE FROM BITPAGOCONCILIADO WHERE ClaveProm = Var_ClaUsuario AND FechaConciliado = DATE(Var_FechaBusqueda);

				INSERT INTO BITPAGOCONCILIADO(
					CreditoID, 		 		NumTransaccionBit,
					Monto,       		 	FechaHoraOper,
					ClaveProm,				ClienteID,
					DispositivoID,     		CuentaAhoID,
					FechaConciliado, 		UsuarioConcil,
					EmpresaID, 		 		Usuario,
					FechaActual, 		 	DireccionIP,
					ProgramaID,				Sucursal,
					NumTransaccion
		      	)
				
			SELECT 	MOVIL.CreditoID, 		IFNULL(SAF.NumTransaccionBit, Entero_Cero) AS NumTransaccionBit,
					MOVIL.Monto,			MOVIL.FechaHoraOper AS FechaOperacion,
					MOVIL.ClaveProm,		MOVIL.ClienteID,
					MOVIL.DispositivoID,	MOVIL.CuentaAhoID,
					Var_FechaBusqueda,		Aud_Usuario,
					Par_EmpresaID,			Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,
					Aud_ProgramaID,			Aud_Sucursal,
					Aud_NumTransaccion
				FROM BITACORAPAGOSMOVILDET AS MOVIL
				LEFT JOIN BITACORAPAGOSSAFI AS SAF ON MOVIL.DispositivoID = SAF.DispositivoID AND MOVIL.ClaveProm = SAF.ClaveProm AND MOVIL.SucursalID = SAF.SucursalID AND MOVIL.CreditoID = SAF.CreditoID AND MOVIL.FolioMovil = SAF.FolioMovil
				WHERE 	(SAF.NumTransaccionBit != 0)
					AND (DATE(MOVIL.FechaHoraOper) = Var_FechaBusqueda)
					AND (MOVIL.ClaveProm = Var_ClaUsuario);

				SET Aux_Contador = Aux_Contador + 1;
			END WHILE;
		END IF;

		IF(Par_ClaveUsu <> Cadena_Vacia) THEN

			DELETE FROM BITPAGOCONCILIADO WHERE ClaveProm = Par_ClaveUsu AND FechaConciliado = Par_FechaConcil;

			INSERT INTO BITPAGOCONCILIADO(
					CreditoID, 		 		NumTransaccionBit,
					Monto,       		 	FechaHoraOper,
					ClaveProm,				ClienteID,
					DispositivoID,     		CuentaAhoID,
					FechaConciliado, 		UsuarioConcil,
					EmpresaID, 		 		Usuario,
					FechaActual, 		 	DireccionIP,
					ProgramaID,				Sucursal,
					NumTransaccion
	      	)
			SELECT 	MOVIL.CreditoID, 		IFNULL(SAF.NumTransaccionBit, Entero_Cero) AS NumTransaccionBit,
					MOVIL.Monto,			MOVIL.FechaHoraOper AS FechaOperacion,
					MOVIL.ClaveProm,		MOVIL.ClienteID,
					MOVIL.DispositivoID,	MOVIL.CuentaAhoID,
					Par_FechaConcil,		Aud_Usuario,
					Par_EmpresaID,			Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,
					Aud_ProgramaID,			Aud_Sucursal,
					Aud_NumTransaccion
				FROM BITACORAPAGOSMOVILDET AS MOVIL
				LEFT JOIN BITACORAPAGOSSAFI AS SAF ON MOVIL.DispositivoID = SAF.DispositivoID AND MOVIL.ClaveProm = SAF.ClaveProm AND MOVIL.SucursalID = SAF.SucursalID AND MOVIL.CreditoID = SAF.CreditoID AND MOVIL.FolioMovil = SAF.FolioMovil
				WHERE 	(SAF.NumTransaccionBit != 0)
					AND (DATE(MOVIL.FechaHoraOper) = Par_FechaConcil)
					AND (MOVIL.ClaveProm = Par_ClaveUsu);

		END IF;

		SET Par_NumErr 		:= Entero_Cero;
		SET Par_ErrMen 		:= 'Proceso Finalizado Exitosamente.';
		SET Var_Control 	:= Cadena_Vacia;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
	 SELECT Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS control,
			Entero_Cero AS consecutivo;
	END IF;

END TerminaStore$$
