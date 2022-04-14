-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDCONOCIMIENTOCTEALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDCONOCIMIENTOCTEALT`;
DELIMITER $$


CREATE PROCEDURE `PLDCONOCIMIENTOCTEALT`(
	-- SP para dar de alta el conocimiento del Cliente
	Par_TipoOperacion		CHAR(3),					-- Tipo de operacion  ACC = Alta conocimiento cliente, MCC = Modifica Conocimiento Cliente
	Par_ClienteIDExt		VARCHAR(20),				-- Cliente ID Externo
	Par_NomGrupo			VARCHAR(100),				-- Nombre del Grupo al cual pertenece
	Par_RFC					VARCHAR(13),				-- RFC del Ciente
	Par_Particip			DECIMAL(14,2),				-- Participacion
	Par_Nacional			VARCHAR(45),				-- Nacionalidad. N=Nacional, E=Extranjero

	Par_RazonSocial			VARCHAR(100),				-- Razon Social
	Par_Giro				VARCHAR(100),				-- Giro empresarial
	Par_PEPs				CHAR(1),					-- Persona politicamente expuesta
	Par_FuncionID			INT,						-- Numero de la Funcion
	Par_ParentesPEP			CHAR(1),					-- Numero del Parentesco PEP. S=SI, N=NO

	Par_NombFam				VARCHAR(50),				-- Nombre del Familiar
	Par_aPaternoFam			VARCHAR(50),				-- Apellido Paterno del Familiar
	Par_aMaternoFam			VARCHAR(50),				-- Apellido Materno del Familiar
	Par_NoEmpleados			CHAR(10),					-- Numero de Empleados
	Par_Serv_Produc			VARCHAR(50),				-- Servicio del Producto

	Par_Cober_Geog			CHAR(1),					-- Cobertura Geografica. E=Estatal, R=Regional, N=Nacional, I=Internacional
	Par_Edos_Presen			VARCHAR(45),				-- Estados en los que tiene Presencia
	Par_ImporteVta			DECIMAL(14,2),				-- Importe Vta
	Par_Activos				DECIMAL(14,2),				-- Activos
	Par_Pasivos				DECIMAL(14,2),				-- Pasivos

	Par_Capital				DECIMAL(14,2),				-- Capital
	Par_Importa				CHAR(1),					-- Indica si importa. S=SI, N=NO
	Par_DolImport			CHAR(5),					-- DOlares importa. Menos de 1000:DImp, 1,001 a 5,000:DImp2, 5,001 a 10,000:DImp3, mayor a 10,001DImp4
	Par_PaisImport			VARCHAR(50),				-- Pais de importacion 1
	Par_PaisImport2			VARCHAR(50),				-- Pais de importacion 2

	Par_PaisImport3			VARCHAR(50),				-- Pais de importacion 3
	Par_Exporta				CHAR(1),					-- Indica si exporta. S=SI, N=NO
	Par_DolExport			CHAR(5),					-- Dolares esporta. Menos de 1000:DExp1, 001 a 5,000: DExp, 5,001 a 10,000:DExp3, mayor a 10001:DExp4
	Par_PaisExport			VARCHAR(50),				-- Pais de exportacion  1
	Par_PaisExport2			VARCHAR(50),				-- Pais de exportacion  2

	Par_PaisExport3			VARCHAR(50),				-- Pais de exportacion  3
	Par_NombRefCom			VARCHAR(50),				-- Nombre de referencia comercial 1
	Par_NombRefCom2			VARCHAR(50),				-- Nombre de referencia comercial 2
	Par_TelRefCom			VARCHAR(20),				-- Telefono de referencia comercial 1
	Par_TelRefCom2			VARCHAR(20),				-- Telefono de referencia comercial 2

	Par_BancoRef			VARCHAR(45),				-- Banco de referencia 1
	Par_BancoRef2			VARCHAR(45),				-- Banco de referencia 2
	Par_NoCtaRef			VARCHAR(30),				-- Numeor de cuenta banco 1
	Par_NoCtaRef2			VARCHAR(30),				-- Numeor de cuenta banco 2
	Par_NombreRef			VARCHAR(50),				-- Nombre de referencia banco 1

	Par_NombreRef2			VARCHAR(50),				-- Nombre de referencia banco 2
	Par_DomRef				VARCHAR(150),				-- Domicilio de referencia 1
	Par_DomRef2				VARCHAR(150),				-- Domicilio de referencia 2
	Par_TelRef				VARCHAR(20),				-- Telefono de referencia 1
	Par_TelRef2				VARCHAR(20),				-- Telefono de referencia 2

	Par_pFteIng     		VARCHAR(100),				-- Principal fuente de Ingresos
	Par_IngAproxMes			VARCHAR(10),				-- Ingresos mensuales
	Par_ExtTelRef1			VARCHAR(6),					-- Extension del telefono referencia 1
	Par_ExtTelRef2			VARCHAR(6),					-- Extension del telefono referencia 2
	Par_ExtTelRefCom		VARCHAR(6),					-- Extension del telefono referencia comercial 1

	Par_ExtTelRefCom2 		VARCHAR(6),					-- Extension del telefono referencia comercial 2
	Par_Relacion1			INT,						-- Relacion 1
	Par_Relacion2			INT,						-- Relacion 2
	Par_PregUno				VARCHAR(100),				-- Pregunta seguridad 1
	Par_RespUno				VARCHAR(200),				-- Respuesta seguridad 2

	Par_PregDos				VARCHAR(100),				-- Pregunta seguridad 2
	Par_RespDos				VARCHAR(200),				-- Respuesta seguridad 2
	Par_PregTres			VARCHAR(100),				-- Pregunta seguridad 3
	Par_RespTres			VARCHAR(200),				-- Respuesta seguridad 2
	Par_PregCuatro			VARCHAR(100),				-- Pregunta seguridad 4

	Par_RespCuatro			VARCHAR(200),				-- Respuesta seguridad 2
	Par_CapitalContable		DECIMAL(14,2),				-- Capital contable
	Par_NivelRiesgo			CHAR(1),					-- Nivel de riesgo. A=Alto, M=Medio, B=Bajo
	Par_EvaluaXMatriz		CHAR(1),					-- Evalua Matriz. S=SI, N=NO
	Par_ComentarioNivel		VARCHAR(200),

	Par_NoCuentaRefCom		VARCHAR(50),				-- Numero de cuenta de la referencia comercial
	Par_NoCuentaRefCom2		VARCHAR(50),				-- Numero de cuenta de la segunda referencia comercial
	Par_DireccionRefCom		VARCHAR(500),				-- Direccion de la referencia comercial
	Par_DireccionRefCom2	VARCHAR(500),				-- Direccion de la segunda referencia comercial
	Par_BanTipoCuentaRef	VARCHAR(50),				-- Tipo de cuenta de la referencia comercial bancaria

	Par_BanTipoCuentaRef2	VARCHAR(50),				-- Tipo de cuenta de la segunda referencia comercial bancaria
	Par_BanSucursalRef		VARCHAR(50),				-- Sucursal de la referencia comercial bancaria
	Par_BanSucursalRef2		VARCHAR(50),				-- Sucursal de la segunda referencia comercial bancaria
	Par_BanNoTarjetaRef		VARCHAR(50),				-- Numero de tarjeta de la referencia comercial bancaria
	Par_BanNoTarjetaRef2	VARCHAR(50),				-- Numero de tarjeta de la segunda referencia comercial bancaria

	Par_BanTarjetaInsRef	VARCHAR(50),				-- Institucion de la tarjeta de la referencia comercial bancaria
	Par_BanTarjetaInsRef2	VARCHAR(50),				-- Institucion de la tarjeta de la segunda referencia comercial bancaria
	Par_BanCredOtraEnt		CHAR(1),					-- Indica si la referencia comercial bancaria tiene o no un credito con otra entidad
	Par_BanCredOtraEnt2		CHAR(1),					-- Indica si la segunda referencia comercial bancaria tiene o no un credito con otra entidad
	Par_BanInsOtraEnt		VARCHAR(50),				-- Institucion con la que la referencia comercial bancaria tiene otro credito

	Par_BanInsOtraEnt2		VARCHAR(50),				-- Institucion con la que la segunda referencia comercial bancaria tiene otro credito
	Par_FechaNombramiento	DATE,				-- Fecha de Nombramiento en caso de PEPs > Parametro para Cuestionarios Adicionales
	Par_PeriodoCargo		VARCHAR(100),		-- Periodo del cargo en caso de PEPs > Parametro para Cuestionarios Adicionales
	Par_PorcentajeAcciones	DECIMAL(10,2),		-- Porcentaje de Acciones en caso de PEPs > Parametro para Cuestionarios Adicionales
	Par_MontoAcciones		DECIMAL(12,2),		-- Monto de las acciones en caso de PEPs > Parametro para Cuestionarios Adicionales

	Par_TiposClientes		CHAR(1),			-- Tipos de Clientes F) Persona Fisica M) Persona Moral > Parametro para Cuestionarios Adicionales.
	Par_InstrumentosMonetarios CHAR(1),			-- Instrumentos monetarios E) Efectivo C) Cheque T) > Transferencia\nParametro para Cuestionarios Adicionales.
	Par_Salida      		CHAR(1),					-- Indicador de Salida
	INOUT Par_NumErr		INT(11),					-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),				-- Mensaje de Error
	-- Parametros de Auditoria
	Aud_EmpresaID			INT,						-- Parametro de Auditoria

	Aud_Usuario				INT,						-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,					-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),				-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),				-- Parametro de Auditoria
	Aud_Sucursal    		INT,						-- Parametro de Auditoria

	Aud_NumTransaccion  BIGINT							-- Parametro de Auditoria
	)

TerminaStore: BEGIN

	-- declaracion de constantes
	DECLARE ActNivelAlto			INT;				-- Actividad de Nivel Alto
	DECLARE ActNivelBajo			INT;				-- Actividad de Nivel Bajo
	DECLARE Alta_ConocimientoCTE	INT(11);			-- Alta Conocimiento del Cliente
	DECLARE Cadena_Vacia			CHAR(1);			-- Cadena Vacia
	DECLARE Cons_Si					CHAR(1);			-- Constante Si
	DECLARE Doble_Cero				INT;				-- Double Cero
	DECLARE Entero_Cero				INT;				-- Entero Cero
	DECLARE Estatus_Activo			CHAR(1);			-- Estatus Activo
	DECLARE Fecha_Vacia				DATE;				-- Fecha Vacia
	DECLARE FisicaActEmp			CHAR(1);			-- Indicador de Fisica con Actividad Empresarial
	DECLARE MenorEdad				CHAR(1);			-- Indicador de Menor de Edad
	DECLARE Moral					CHAR(1);			-- Indicador de Persona Moral
	DECLARE NacionExt				CHAR(1);			-- Indicador de Nacionalidad Extranjera
	DECLARE NacionMex				CHAR(1);			-- Indicador de Nacionalidad Mexicana
	DECLARE NivelBajo				CHAR(1);			-- Indicador de Nivel Bajo
	DECLARE PEP_No					CHAR(1);			-- Indicador de PEPs NO
	DECLARE PEP_Si					CHAR(1);			-- Indicador de PEPs SI
	DECLARE SalidaNO				CHAR(1);			-- Indicador de Salida NO
	DECLARE SalidaSI				CHAR(1);			-- Indicador de Salida SI

	-- declaracion de variables
	DECLARE Var_TipoPersona			CHAR(1);			-- Tipo de Persona
	DECLARE Var_SI					CHAR(1);			-- Indicador de SI
	DECLARE Var_NO					CHAR(1);			-- Indicador de NO
	DECLARE Var_Local				CHAR(1);			-- Local
	DECLARE Var_Est					CHAR(1);			-- Estatal
	DECLARE Var_Reg					CHAR(1);			-- Regional
	DECLARE Var_Nac					CHAR(1);			-- Nacional
	DECLARE Var_Inter				CHAR(1);			-- Internacional
	DECLARE Var_NivelRiesgoCte		CHAR(1);			-- Nivel de Riesgo del Cliente
	DECLARE Var_ActividadBancoMX	VARCHAR(15);		-- Actividad BMX
	DECLARE Var_NivelClaveRiesgo	CHAR(1);			-- Clave del Nivel de Riesgo
	DECLARE Var_NumActualizacion	INT;				-- Numero de Actualizacion
	DECLARE Var_Control				VARCHAR(50);		-- Control en pantalla
	DECLARE Var_NacionCte			CHAR(1);			-- Nacionalidad del Cliente
	DECLARE Var_NivelRiesgo			CHAR(1);			-- Nivel de Riesgo
	DECLARE Var_FechaActual			DATE;				-- Fehca Actual
	DECLARE Var_ClienteID			INT(11);			-- Numero de Cliente en el SAFI
	DECLARE Var_Consecutivo 		VARCHAR(200);		-- Numero Consecutivo del Registro
	DECLARE Var_OpAltConoCliente	CHAR(3);			-- Operacion alta de conocimiento del cliente
	DECLARE Var_OpModConoCliente	CHAR(3);			-- Operacion modificacion de conocimiento del cliente

	-- asignacion de constantes
	SET ActNivelAlto				:= 8;				-- Tipo de Actualizacion para el Nivel de Riesgo alto
	SET ActNivelBajo				:= 9;				-- Tipo de Actualizacion para el Nivel de Riesgo a BAJO
	SET Alta_ConocimientoCTE		:= 3;				-- Alta Conocimiento del Cliente
	SET Cadena_Vacia				:= '';				-- Cadena o String Vacio
	SET Cons_Si						:= 'S';				-- Constante SI
	SET Doble_Cero					:= 0.0;				-- Decimal Cero
	SET Entero_Cero					:= 0;				-- Entero Cero
	SET Estatus_Activo				:= 'A';				-- Estatus Activo
	SET Fecha_Vacia					:= '1900-01-01';	-- Fecha Vacia
	SET FisicaActEmp				:= 'A';				-- Tipo de persona Fisica con Actividad Empresarial
	SET MenorEdad					:= 'S';				-- Si es Menor de Edad
	SET Moral						:= 'M';				-- Tipo de persona Moral
	SET NacionExt					:= 'E';				-- Nacionalidad Extranjera
	SET NacionMex					:= 'N';				-- Nacionalidad Mexicana (Nacional)
	SET NivelBajo					:='B';				-- Nivel de Riesgo BAJO
	SET Par_ErrMen					:= '';				-- Mensaje de error para llamadas CALL (Eliminar si se recibe de parametro de entrada)
	SET Par_NumErr					:= 0;				-- Numero de error para llamadas CALL (Eliminar si se recibe de parametro de entrada)
	SET PEP_No						:= 'N';				-- No es PEP
	SET PEP_Si						:= 'S';				-- Si es PEP
	SET SalidaNO					:= 'N';				-- Salida No
	SET SalidaSI					:= 'S';				-- Salida Si

	SET Var_SI						:= 'S';				-- Constante SI
	SET Var_NO						:= 'N';				-- Constante NO
	SET Var_Local					:= 'L';				-- Constante Local
	SET Var_Est						:= 'E';				-- Constante Nacional
	SET Var_Reg						:= 'R';				-- Constante Regional
	SET Var_Nac						:= 'N';				-- Constante Nacional
	SET Var_Inter					:= 'I';				-- Constante Internacional
	
	SET Var_OpAltConoCliente		:= 'ACC';			-- Alta conocimiento de cuenta
	SET Var_OpModConoCliente		:= 'MCC';			-- Modificacion de conocimiento de cuenta
	
	ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr := 999;
		SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
				  'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDCONOCIMIENTOCTEALT');
	END;
	
	IF(Par_TipoOperacion = Cadena_Vacia) THEN
			SET Par_NumErr	:=   003;
			SET Par_ErrMen	:= 'El tipo de operacion se ecuentra vacio';
			SET Var_Control	:= 'ClienteIDExt';
			LEAVE ManejoErrores;
	END IF;
	
	IF(Par_TipoOperacion != Var_OpAltConoCliente AND Par_TipoOperacion != Var_OpModConoCliente) THEN
			SET Par_NumErr	:=   004;
			SET Par_ErrMen	:= 'El tipo de operacion no es valido';
			SET Var_Control	:= 'ClienteIDExt';
			LEAVE ManejoErrores;
	END IF;
	

	SET Par_ClienteIDExt	:= IFNULL(Par_ClienteIDExt,Cadena_Vacia);

	IF(Par_ClienteIDExt = Cadena_Vacia) THEN
		SET Par_NumErr			:= 001;
		SET Par_ErrMen			:= 'El Numero del Cliente se encuentra vacio.' ;
		SET Var_Control			:= 'Par_ClienteIDExt';
		SET Var_Consecutivo		:= Entero_Cero;
		LEAVE ManejoErrores;
	END IF;

	SELECT ClienteID
	INTO Var_ClienteID
	FROM PLDCLIENTES
	WHERE ClienteIDExt = Par_ClienteIDExt;

	SET Var_ClienteID := IFNULL(Var_ClienteID,Entero_Cero);

	IF(IFNULL( Var_ClienteID, Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr			:= 002;
		SET Par_ErrMen			:= 'El Cliente ingresado no existe.';
		SET Var_Control			:= 'Var_ClienteID';
		SET Var_Consecutivo 	:= Entero_Cero;
		LEAVE ManejoErrores;
	END IF;

	SET Aud_FechaActual		:= NOW();
	
	-- Registro conocimiento cliente
	IF(Par_TipoOperacion = Var_OpAltConoCliente) THEN 
		
		CALL CONOCIMIENTOCTEALT(
			Var_ClienteID,			Par_NomGrupo,				Par_RFC	,					Par_Particip,				Par_Nacional,
			Par_RazonSocial,		Par_Giro,					Par_PEPs,					Par_FuncionID,				Par_ParentesPEP,
			Par_NombFam,			Par_aPaternoFam,			Par_aMaternoFam,			Par_NoEmpleados,			Par_Serv_Produc,
			Par_Cober_Geog,			Par_Edos_Presen,			Par_ImporteVta,				Par_Activos,				Par_Pasivos,
			Par_Capital,			Par_Importa,				Par_DolImport,				Par_PaisImport,				Par_PaisImport2,
			Par_PaisImport3,		Par_Exporta,				Par_DolExport,				Par_PaisExport,				Par_PaisExport2,
			Par_PaisExport3,		Par_NombRefCom,				Par_NombRefCom2,			Par_TelRefCom,				Par_TelRefCom2,
			Par_BancoRef,			Par_BancoRef2,				Par_NoCtaRef,				Par_NoCtaRef2,				Par_NombreRef,
			Par_NombreRef2,			Par_DomRef,					Par_DomRef2,				Par_TelRef,					Par_TelRef2,
			Par_pFteIng,			Par_IngAproxMes,			Par_ExtTelRef1,				Par_ExtTelRef2,				Par_ExtTelRefCom,
			Par_ExtTelRefCom2,		Par_Relacion1,				Par_Relacion2,				Par_PregUno,				Par_RespUno,
			Par_PregDos,			Par_RespDos,				Par_PregTres,				Par_RespTres,				Par_PregCuatro,
			Par_RespCuatro,			Par_CapitalContable,		Par_NivelRiesgo,			Par_EvaluaXMatriz,			Par_ComentarioNivel,
			Par_NoCuentaRefCom,		Par_NoCuentaRefCom2,		Par_DireccionRefCom,		Par_DireccionRefCom2,		Par_BanTipoCuentaRef,
			Par_BanTipoCuentaRef2,	Par_BanSucursalRef,			Par_BanSucursalRef2,		Par_BanNoTarjetaRef,		Par_BanNoTarjetaRef2,
			Par_BanTarjetaInsRef,	Par_BanTarjetaInsRef2,		Par_BanCredOtraEnt,			Par_BanCredOtraEnt2,		Par_BanInsOtraEnt,
			Par_BanInsOtraEnt2,		Par_FechaNombramiento,		Par_PeriodoCargo,			Par_PorcentajeAcciones,		Par_MontoAcciones,
			Par_TiposClientes,		Par_InstrumentosMonetarios, Entero_Cero, 				Entero_Cero,				SalidaNO,
			Par_NumErr,				Par_ErrMen,					Aud_EmpresaID,				Aud_Usuario,				Aud_FechaActual,
			Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,				Aud_NumTransaccion);

		IF(Par_NumErr!=Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
		
		SET	Par_ErrMen		:= CONCAT('Conocimiento del Cliente Agregado Exitosamente.');
	END IF;
	
	-- Modificacion de conocimiento de cliente
	IF(Par_TipoOperacion = Var_OpModConoCliente )THEN
		CALL CONOCIMIENTOCTEMOD(
			Var_ClienteID,			Par_NomGrupo,				Par_RFC	,					Par_Particip,				Par_Nacional,
			Par_RazonSocial,		Par_Giro,					Par_PEPs,					Par_FuncionID,				Par_ParentesPEP,
			Par_NombFam,			Par_aPaternoFam,			Par_aMaternoFam,			Par_NoEmpleados,			Par_Serv_Produc,
			Par_Cober_Geog,			Par_Edos_Presen,			Par_ImporteVta,				Par_Activos,				Par_Pasivos,
			Par_Capital,			Par_Importa,				Par_DolImport,				Par_PaisImport,				Par_PaisImport2,
			Par_PaisImport3,		Par_Exporta,				Par_DolExport,				Par_PaisExport,				Par_PaisExport2,
			Par_PaisExport3,		Par_NombRefCom,				Par_NombRefCom2,			Par_TelRefCom,				Par_TelRefCom2,
			Par_BancoRef,			Par_BancoRef2,				Par_NoCtaRef,				Par_NoCtaRef2,				Par_NombreRef,
			Par_NombreRef2,			Par_DomRef,					Par_DomRef2,				Par_TelRef,					Par_TelRef2,
			Par_pFteIng,			Par_IngAproxMes,			Par_ExtTelRef1,				Par_ExtTelRef2,				Par_ExtTelRefCom,
			Par_ExtTelRefCom2,		Par_Relacion1,				Par_Relacion2,				Par_PregUno,				Par_RespUno,
			Par_PregDos,			Par_RespDos,				Par_PregTres,				Par_RespTres,				Par_PregCuatro,
			Par_RespCuatro,			Par_CapitalContable,		Par_NivelRiesgo,			Par_EvaluaXMatriz,			Par_ComentarioNivel,
			Par_NoCuentaRefCom,		Par_NoCuentaRefCom2,		Par_DireccionRefCom,		Par_DireccionRefCom2,		Par_BanTipoCuentaRef,
			Par_BanTipoCuentaRef2,	Par_BanSucursalRef,			Par_BanSucursalRef2,		Par_BanNoTarjetaRef,		Par_BanNoTarjetaRef2,
			Par_BanTarjetaInsRef,	Par_BanTarjetaInsRef2,		Par_BanCredOtraEnt,			Par_BanCredOtraEnt2,		Par_BanInsOtraEnt,
			Par_BanInsOtraEnt2,		Par_FechaNombramiento,		Par_PeriodoCargo,			Par_PorcentajeAcciones,		Par_MontoAcciones,
			Par_TiposClientes,		Par_InstrumentosMonetarios,	Entero_Cero,				Entero_Cero,				SalidaNO,
			Par_NumErr,				Par_ErrMen,					Aud_EmpresaID,				Aud_Usuario,				Aud_FechaActual,
			Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,				Aud_NumTransaccion);

		IF(Par_NumErr!=Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
		
		SET	Par_ErrMen		:= CONCAT('Conocimiento del Cliente Modificado Exitosamente.');
	END IF;

	SET	Par_NumErr		:= 000;
	SET Var_Control 	:= 'clienteID' ;
	SET Var_Consecutivo	:= Par_ClienteIDExt;

	END ManejoErrores;

	IF Par_Salida = Var_SI THEN
		SELECT Par_NumErr AS NumErr,
		Par_ErrMen  AS ErrMen,
		Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$
