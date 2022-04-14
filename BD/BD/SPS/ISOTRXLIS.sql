-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ISOTRXLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ISOTRXLIS`;

DELIMITER $$
CREATE PROCEDURE `ISOTRXLIS`(
	-- Store Procedure para obtener los Elementos de la peticion JSON para ISOTRX al Cierre de Dia
	-- Modulo Tarjetas de Debido WS ISOTRX
	Par_PIDTarea				VARCHAR(50),		-- PDI de Tarea
	Par_TipoLista				TINYINT UNSIGNED,	-- Numero de Lista

	Aud_EmpresaID 				INT(11),			-- Parametro de Auditoria Empresa ID
	Aud_Usuario 				INT(11),			-- Parametro de Auditoria Usuario ID
	Aud_FechaActual 			DATE,				-- Parametro de Auditoria Fecha Actual
	Aud_DireccionIP 			VARCHAR(15),		-- Parametro de Auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de Auditoria Programa ID
	Aud_Sucursal				INT(11),			-- Parametro de Auditoria Sucursal ID
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de Auditoria Numero Transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_DescripcionMov				VARCHAR(200);		-- Variable para almacenar la Descripcion de la operacion
	DECLARE Var_PrefijoEmisor				VARCHAR(200);		-- Variable para almacenar el valor del campo PrefijoEmisor
	DECLARE Var_IDEmisor					VARCHAR(200);		-- Variable para almacenar el valor del campo IDEmisor
	DECLARE Var_RutaConWSAutoriza			VARCHAR(200);		-- Variable para almacenar el valor del campo RutaConWSAutoriza
	DECLARE Var_TimeOutConWSAutoriza		VARCHAR(200);		-- Variable para almacenar el valor del campo TimeOutConWSAutoriza

	DECLARE Var_UsuarioConWSAutoriza		VARCHAR(200);		-- Variable para almacenar el valor del campo UsuarioConWSAutoriza
	DECLARE Var_OperacionPeticion			VARCHAR(200);		-- Variable para almacenar el valor del campo OperacionPeticion
	DECLARE Var_RutaConSAFIWS				VARCHAR(200);		-- Variable para almacenar el valor del campo RutaConSAFIWS
	DECLARE Var_UsuarioConSAFIWS			VARCHAR(200);		-- Variable para almacenar el valor del campo UsuarioConSAFIWS
	DECLARE Var_TarjetaPeticionSAFI			VARCHAR(200);		-- Variable para almacenar el valor del campo TarjetaPeticionSAFI

	DECLARE Var_OperacionPeticionSAFI		VARCHAR(200);		-- Variable para almacenar el valor del campo OperacionPeticionSAFI
	DECLARE Var_TipoOperacion				TINYINT UNSIGNED;	-- Tipo de Operacion
	DECLARE Var_EsCierreDia					INT(11);			-- Es Cierre de Dia

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia					CHAR(1);			-- Constante Cadena Vacia
	DECLARE Entero_Cero						INT(11);			-- Constante Entero Vacio
	DECLARE Decimal_Cero					DECIMAL(12,2);		-- Constante Decimal Vacio
	DECLARE Fecha_Vacia						DATE;				-- Constante Fecha Vacia
	DECLARE Est_Activada					INT(11);			-- Constante Estatus Activada

	DECLARE Con_TarjetaDebito				INT(11);			-- Tipo Tarjeta Debito
	DECLARE Default_TimeOut					INT(11);			-- Constante Time out Default
	DECLARE Con_NO 							CHAR(1);			-- Constante NO
	DECLARE Con_SI							CHAR(1);			-- Constante SI
	DECLARE Est_Pendiente					CHAR(1);			-- Estatus Pendiente

	DECLARE Con_MonedaMX					CHAR(3);			-- Moneda Mexicana
	DECLARE Llave_IDEmisor					VARCHAR(50);		-- Llave IDEmisor
	DECLARE Llave_PrefijoEmisor				VARCHAR(50);		-- Llave PrefijoEmisor
	DECLARE Llave_RutaConWSAutoriza			VARCHAR(50);		-- Llave RutaConWSAutoriza
	DECLARE Llave_TimeOutConWSAutoriza		VARCHAR(50);		-- Llave TimeOutConWSAutoriza

	DECLARE Llave_UsuarioConWSAutoriza		VARCHAR(50);		-- Llave UsuarioConWSAutoriza
	DECLARE Llave_OperacionPeticion			VARCHAR(50);		-- Llave OperacionPeticion
	DECLARE Llave_RutaConSAFIWS				VARCHAR(50);		-- Llave RutaConSAFIWS
	DECLARE Llave_UsuarioConSAFIWS			VARCHAR(50);		-- Llave UsuarioConSAFIWS
	DECLARE Llave_TarjetaPeticionSAFI		VARCHAR(50);		-- Llave TarjetaPeticionSAFI

	DECLARE Llave_OperacionPeticionSAFI		VARCHAR(50);		-- Llave OperacionPeticionSAFI
	DECLARE Con_OperacionCierreDia			TINYINT UNSIGNED;	-- Tipo de Operacion Cierre de Día

	-- Declaracion de Consultas
	DECLARE Lis_NotificacionOperacion		TINYINT UNSIGNED;	-- Consulta Notificacion Operacion Peticion al Dia

	-- Asginacion de Constantes
	SET Cadena_Vacia					:= '';
	SET Entero_Cero						:= 0;
	SET Decimal_Cero					:= 0.00;
	SET Fecha_Vacia						:= '1900-01-01';
	SET Est_Activada					:= 7;

	SET Con_TarjetaDebito				:= 1;
	SET Default_TimeOut					:= 60000;
	SET Con_NO 							:= 'N';
	SET Con_SI							:= 'S';
	SET Est_Pendiente					:= 'P';

	SET Con_MonedaMX					:= '484';
	SET Llave_IDEmisor					:= 'IDEmisor';
	SET Llave_PrefijoEmisor				:= 'PrefijoEmisor';
	SET Llave_RutaConWSAutoriza			:= 'RutaConWSAutoriza';
	SET Llave_TimeOutConWSAutoriza		:= 'TimeOutConWSAutoriza';

	SET Llave_UsuarioConWSAutoriza		:= 'UsuarioConWSAutoriza';
	SET Llave_OperacionPeticion			:= 'OperacionPeticion';
	SET Llave_RutaConSAFIWS				:= 'RutaConSAFIWS';
	SET Llave_UsuarioConSAFIWS			:= 'UsuarioConSAFIWS';
	SET Llave_TarjetaPeticionSAFI		:= 'TarjetaPeticionSAFI';

	SET Llave_OperacionPeticionSAFI		:= 'OperacionPeticionSAFI';
	SET Con_OperacionCierreDia			:= 20;

	-- Investigar como colocar el time out y desarrollar el metodo y si no se inicializa colocar un timeout por defecto (60 segundo)
	-- Asignacion de Consultas
	SET Lis_NotificacionOperacion		:= 1;


	-- Declaracion de Variables
	SET Var_IDEmisor					:= IFNULL( FNPARAMTARJETAS(Llave_IDEmisor), Entero_Cero);
	SET Var_PrefijoEmisor				:= IFNULL( FNPARAMTARJETAS(Llave_PrefijoEmisor), Cadena_Vacia);
	SET Var_RutaConWSAutoriza 			:= IFNULL( FNPARAMTARJETAS(Llave_RutaConWSAutoriza), Cadena_Vacia);
	SET Var_TimeOutConWSAutoriza 		:= IFNULL( FNPARAMTARJETAS(Llave_TimeOutConWSAutoriza), Default_TimeOut);
	SET Var_UsuarioConWSAutoriza 		:= IFNULL( FNPARAMTARJETAS(Llave_UsuarioConWSAutoriza), Cadena_Vacia);
	SET Var_RutaConSAFIWS 				:= IFNULL( FNPARAMTARJETAS(Llave_RutaConSAFIWS), Cadena_Vacia);
	SET Var_UsuarioConSAFIWS 			:= IFNULL( FNPARAMTARJETAS(Llave_UsuarioConSAFIWS), Cadena_Vacia);
	SET Var_OperacionPeticion			:= IFNULL( FNPARAMTARJETAS(Llave_OperacionPeticion), Cadena_Vacia);
	SET Var_TarjetaPeticionSAFI			:= IFNULL( FNPARAMTARJETAS(Llave_TarjetaPeticionSAFI), Cadena_Vacia);
	SET Var_OperacionPeticionSAFI		:= IFNULL( FNPARAMTARJETAS(Llave_OperacionPeticionSAFI), Cadena_Vacia);

	IF( Par_TipoLista = Lis_NotificacionOperacion ) THEN

		SELECT IFNULL(COUNT(OperacionPeticionID), Entero_Cero)
		INTO Var_EsCierreDia
		FROM ISOTRXTARNOTIFICA
		WHERE OperacionPeticionID = Con_OperacionCierreDia;

		IF( Var_EsCierreDia > Entero_Cero ) THEN
			SELECT
				CONCAT(Var_RutaConWSAutoriza,Var_OperacionPeticion) AS RutaConWSAutoriza,
				Var_TimeOutConWSAutoriza 						AS TimeOutConWSAutoriza,
				Var_UsuarioConWSAutoriza 						AS UsuarioConWSAutoriza,

				Var_IDEmisor 									AS IDEmisor,
				CONCAT(Var_PrefijoEmisor,Iso.Transaccion)		AS PrefijoEmisor,
				Rel.CodigoOperacion								AS TipoOperacion,
				REPLACE(DATE(NOW()), '-','')					AS FechaPeticion,
				REPLACE(TIME(NOW()), ':','')					AS HoraPeticion,

				Entero_Cero 									AS NumeroAfiliacion,
				Rel.Descripcion 								AS NombreComercio,
				Iso.CuentaAhoID 								AS NumeroCuenta,
				Iso.TarjetaID									AS NumeroTarjeta,
				Con_MonedaMX									AS CodigoMoneda,

				IFNULL(Iso.MontoOperacion, Decimal_Cero)		AS MontoTransaccion,
				Decimal_Cero									AS MontoAdicional,
				Decimal_Cero									AS MontoComision,
				Cadena_Vacia									AS OriCodigoAutorizacion,
				Con_TarjetaDebito								AS TipoTarjeta,
				Iso.FechaOperacion								AS FechaOperacion,
				Iso.RegistroID									AS RegistroID,
				Iso.PIDTarea 									AS PIDTarea,
				Aud_NumTransaccion 								AS Transaccion,
				CONCAT(Var_RutaConSAFIWS,Var_OperacionPeticionSAFI) AS RutaConSAFIWS,
				Var_UsuarioConSAFIWS 							AS UsuarioConSAFIWS
			FROM ISOTRXTARNOTIFICA Iso
			INNER JOIN RELOPERAPETICIONISOTRX Rel ON Iso.OperacionPeticionID = Rel.OperacionPeticionID
			WHERE Iso.TipoTarjeta = Con_TarjetaDebito
			  AND Iso.OperacionPeticionID = Con_OperacionCierreDia
			  AND Iso.Estatus = Est_Pendiente
			  AND Iso.PIDTarea = Par_PIDTarea;
		ELSE
			SELECT
				CONCAT(Var_RutaConWSAutoriza,Var_OperacionPeticion) AS RutaConWSAutoriza,
				Var_TimeOutConWSAutoriza 						AS TimeOutConWSAutoriza,
				Var_UsuarioConWSAutoriza 						AS UsuarioConWSAutoriza,

				Var_IDEmisor 									AS IDEmisor,
				CONCAT(Var_PrefijoEmisor,Iso.Transaccion)		AS PrefijoEmisor,
				Rel.CodigoOperacion								AS TipoOperacion,
				REPLACE(DATE(NOW()), '-','')					AS FechaPeticion,
				REPLACE(TIME(NOW()), ':','')					AS HoraPeticion,

				Entero_Cero 									AS NumeroAfiliacion,
				Rel.Descripcion 								AS NombreComercio,
				Iso.CuentaAhoID 								AS NumeroCuenta,
				Iso.TarjetaID									AS NumeroTarjeta,
				Con_MonedaMX									AS CodigoMoneda,

				IFNULL(Iso.MontoOperacion, Decimal_Cero)		AS MontoTransaccion,
				Decimal_Cero									AS MontoAdicional,
				Decimal_Cero									AS MontoComision,
				Cadena_Vacia									AS OriCodigoAutorizacion,
				Con_TarjetaDebito								AS TipoTarjeta,
				Iso.FechaOperacion								AS FechaOperacion,
				Iso.RegistroID									AS RegistroID,
				Iso.PIDTarea 									AS PIDTarea,
				Aud_NumTransaccion 								AS Transaccion,
				CONCAT(Var_RutaConSAFIWS,Var_OperacionPeticionSAFI) AS RutaConSAFIWS,
				Var_UsuarioConSAFIWS 							AS UsuarioConSAFIWS
			FROM ISOTRXTARNOTIFICA Iso
			INNER JOIN RELOPERAPETICIONISOTRX Rel ON Iso.OperacionPeticionID = Rel.OperacionPeticionID
			WHERE Iso.TipoTarjeta = Con_TarjetaDebito
			  AND Iso.Estatus = Est_Pendiente
			  AND Iso.PIDTarea = Par_PIDTarea;
		END IF;
	END IF;

END TerminaStore$$