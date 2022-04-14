-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTRATOSOLICITUDCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTRATOSOLICITUDCON`;
DELIMITER $$

CREATE PROCEDURE `CONTRATOSOLICITUDCON`(
-- SP PARA CONSULTAR LOS DATOS DE LA SOLICITUD DE CREDITO DIVIDIDOS POR TIPO DE REPORTE
	Par_SolCredID	BIGINT(20),			-- Numero de Solicitud de Credito
	Par_NumCon		TINYINT UNSIGNED,	-- Numero de Consulta

	-- AUDITORIA GENERAL
    Aud_EmpresaID		INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario			INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual		DATETIME,		-- Parametro de auditoria Fecha actual
	Aud_DireccionIP		VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID		VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal		INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion	BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

-- DECLARACION DE CONSTANTES
    DECLARE	Cadena_Vacia	CHAR(1);	    -- Cadena vacia
	DECLARE	Fecha_Vacia		DATE;		    -- Fecha vacia
	DECLARE	Entero_Cero		INT(11);	    -- Entero en cero
    DECLARE	Entero_Uno		INT(11);	    -- Entero en uno
    DECLARE	Entero_Dos		INT(11);	    -- Entero en dos
    DECLARE	Entero_Tres		INT(11);	    -- Entero tres
    DECLARE	Decimal_Cero	DECIMAL(12,2);	-- Decimal en cero
    DECLARE NOENCONTRADO	VARCHAR(100);	-- Valor que indica que no existe
    -- CONSULTA DEL REPORTE - CON RECA
	DECLARE Con_SegA	    INT(2);	  	    -- 01 _ ANEXO A
	DECLARE Con_SegB	    INT(2);	  	    -- 02 _ ANEXO B
	DECLARE Con_SegC	    INT(2);	  	    -- 03 _ ANEXO C
	DECLARE Con_SegD	    INT(2);	 		-- 04 _ CONTRATO APERTURA DE CREDITO AViO AGROPECUARIO
	DECLARE Con_SegE	    INT(2);	 		-- 05 _ PRECEPTOS LEGALES
	DECLARE Con_SegF	    INT(2);  		-- 06 _ SOLICITUD DE CREDITO DE PERSONA FISICA
	DECLARE Con_SegG	    INT(2);	  		-- 07 _ SOLICITUD DE CREDITO DE PERSONA MORAL  
	-- CONSULTA DEL REPORTE - SIN RECA
	DECLARE Con_SegH	    INT(2);	  		-- 08 _ AUTORIZACION DE CARGO AUTOMATICO
	DECLARE Con_SegI	    INT(2);	        -- 09 _ CESION DE DERECHOS
	DECLARE Con_SegJ	    INT(2);	      	-- 10 _ DECLARATORIA DUD
	DECLARE Con_SegK	    INT(2);		    -- 11 _ PAGARE PAGO UNICO INTERES MENSUAL DUD
	DECLARE Con_SegL	    INT(2);		    -- 12 _ PAGARE PAGO UNICO
	DECLARE Con_SegM	    INT(2);			-- 13 _ PAGOS ADELANTADOS OK

-- DECLARACION DE VARIABLES
    DECLARE Var_SolCredID	BIGINT(20);		-- ID de la Solicitud de Credito
    -- numCon 1
    DECLARE Var_Aseguradora VARCHAR(50); 	-- Aseguradora                          NUEVO
    DECLARE Var_MontoAmpSV  DECIMAL(14, 2); -- Monto amparado del Seguro de Vida    NUEVO
    DECLARE Var_NumPoliza	BIGINT(20);	    -- Numero de poliza                     NUEVO
    DECLARE Var_VigInicioSV DATE; 		    -- Vigencia inicio del Seguro de Vida   NUEVO
    DECLARE Var_CoberturaSV VARCHAR(50);    -- Cobertura del Seguro de Vida         NUEVO
    DECLARE Var_VigFinSV    DATE;           -- Vigencia fin del Seguro de Vida      NUEVO
    DECLARE Var_TipoOpe         VARCHAR(100);
    DECLARE Var_ClaSegVid       VARCHAR(100);
    DECLARE Var_SeguroDan       DECIMAL(12,2);
    DECLARE Var_ClaSegDa        VARCHAR(100);
    -- numCon 3
    DECLARE Var_ValorCom	DECIMAL(14,2);	-- Valor Comercial
	-- numCon 4
	DECLARE Var_MunicipioID	INT(11);		-- Sucursal Municipio
    DECLARE Var_EstadoID	INT(11);		-- Sucursal Estado
    DECLARE Var_MunIDDes	VARCHAR(100);	-- Sucursal Descripcion Municipio
    DECLARE Var_EdoIDDes	VARCHAR(100);	-- Sucursal Descripcion Estado
    DECLARE Var_SucDirec	VARCHAR(200);	-- Sucursal Direccion
    
    DECLARE Var_MonAvaluo	DECIMAL(21,2);	-- Monto Avaluo
    DECLARE Var_FecVerif	DATE;			-- Fecha Verificacion
    DECLARE Var_TipoPiso	VARCHAR(70);	-- Tipo Piso
    DECLARE Var_NomVal		VARCHAR(100);	-- Nombre del Valuador
    DECLARE Var_NumAvaluo	VARCHAR(10);	-- Numero Avaluo
	DECLARE Var_FecValua	DATE;			-- Fecha Evaluacion
    DECLARE Var_ClasGarID	INT(11);		-- Clasificacion Garantia
    DECLARE Var_TipGarID	INT(11);		-- Tipo Garantia
    
    DECLARE Var_FechaFin	DATE;			-- Fecha Final
    DECLARE Var_MontoGarLiq	DECIMAL(14,2);	-- Monto Garantia Liquida
    DECLARE Var_CuentaAhoID	INT(11);		-- Cuenta Ahorro
    DECLARE Var_SucursalID	INT(11);		-- Sucursal
	DECLARE Var_SucursalDes	VARCHAR(200);	-- Descripcion de la Sucursal

    DECLARE Var_ClienteID	INT(11);		-- ID del Cliente
    DECLARE Var_ProspecID	BIGINT(20);		-- ID del Prospecto
    DECLARE Var_MontoSol	DECIMAL(12,2);	-- Monto Solicitado
    DECLARE Var_DestCreID	INT(11);		-- Destino del Credito
    DECLARE Var_DestCreDes	VARCHAR(500);	-- Descripcion del Destino del Credito

    DECLARE Var_ProdCredID	INT(11);		-- Producto del Credito
    DECLARE Var_ProdCredDes	VARCHAR(100);	-- Descripcion del Producto del Credito
    DECLARE Var_PlazoID		VARCHAR(20);	-- Plazo
    DECLARE Var_PlazoDes	VARCHAR(100);	-- Descripcion del Plazo
    DECLARE Var_TasaFija	DECIMAL(8,4);	-- Tasa Fija

    DECLARE Var_FrecCap		CHAR(1);		-- Frecuencia Capital
    DECLARE Var_FrecCapDes	VARCHAR(100);	-- Descripcion Frecuencia Capital
	DECLARE EstCuenA		CHAR(1);
	DECLARE EstInvN 		CHAR(1);		-- Estatus Inversion N - Vigente
    DECLARE FrecCapS		CHAR(1);		-- Frecuencia Capital S
    DECLARE FrecCapC		CHAR(1);		-- Frecuencia Capital C
    DECLARE FrecCapQ		CHAR(1);		-- Frecuencia Capital Q

    DECLARE FrecCapM	CHAR(1);	-- Frecuencia Capital M
    DECLARE FrecCapP	CHAR(1);	-- Frecuencia Capital P
    DECLARE FrecCapB	CHAR(1);	-- Frecuencia Capital B
    DECLARE FrecCapT	CHAR(1);	-- Frecuencia Capital T
    DECLARE FrecCapR	CHAR(1);	-- Frecuencia Capital R

    DECLARE FrecCapE	CHAR(1);	-- Frecuencia Capital E
    DECLARE FrecCapA	CHAR(1);	-- Frecuencia Capital A
    DECLARE FrecCapL	CHAR(1);	-- Frecuencia Capital L
    DECLARE FrecCapU	CHAR(1);	-- Frecuencia Capital U
    DECLARE FrecCapD	CHAR(1);	-- Frecuencia Capital D

    DECLARE FrecCapSDes	VARCHAR(100);	-- Descripcion Frecuencia Capital S
    DECLARE FrecCapCDes	VARCHAR(100);	-- Descripcion Frecuencia Capital C
    DECLARE FrecCapQDes	VARCHAR(100);	-- Descripcion Frecuencia Capital Q
    DECLARE FrecCapMDes	VARCHAR(100);	-- Descripcion Frecuencia Capital M
    DECLARE FrecCapPDes	VARCHAR(100);	-- Descripcion Frecuencia Capital P

    DECLARE FrecCapBDes	VARCHAR(100);	-- Descripcion Frecuencia Capital B
    DECLARE FrecCapTDes	VARCHAR(100);	-- Descripcion Frecuencia Capital T
    DECLARE FrecCapRDes	VARCHAR(100);	-- Descripcion Frecuencia Capital R
    DECLARE FrecCapEDes	VARCHAR(100);	-- Descripcion Frecuencia Capital E
    DECLARE FrecCapADes	VARCHAR(100);	-- Descripcion Frecuencia Capital A

    DECLARE FrecCapLDes		VARCHAR(100);	-- Descripcion Frecuencia Capital L
    DECLARE FrecCapUDes		VARCHAR(100);	-- Descripcion Frecuencia Capital U
    DECLARE FrecCapDDes		VARCHAR(100);	-- Descripcion Frecuencia Capital D
    DECLARE Var_MonedaID	INT(11);		-- Moneda
    DECLARE Var_MonedaDes	VARCHAR(80);	-- Descripcion Moneda

    DECLARE Var_Estatus		CHAR(1);		-- Estatus de la Solicitud Credito
	
    -- numCon 6
    DECLARE Var_FecAutORech	DATE;			-- Fecha de Autizada o Rechazada
    DECLARE Var_ResolAut    CHAR(1);        -- Resolucion Aprobada NUEVO
    DECLARE Var_ResolRech   CHAR(1);        -- Resolucion Rechazada NUEVO

    DECLARE Var_PromotorID	INT(11);		-- Promotor
    DECLARE Var_PromNombre	VARCHAR(100);	-- Nombre del Promotor
    DECLARE Var_DiaMes		INT(3);			-- Dia Seleccionado en la Solicitud

    DECLARE Var_GradoEsc	INT(3);			-- Grado Escolar
    DECLARE Var_GradoEscDes	VARCHAR(100);	-- Descripcion Grado Escolar
    DECLARE Var_TipoMat		INT(3);			-- Tipo Material
    DECLARE Var_TipoMatDes	VARCHAR(100);	-- Descripcion Tipo Material
    DECLARE Var_ValorViv	DECIMAL(18,2);	-- Valor Vivienda

    DECLARE Var_CYPriNombre	VARCHAR(100);	-- Conyugue Primer Nombre
	DECLARE Var_CYOcupaID	INT(11);		-- Conyugue Ocupacion
    DECLARE Var_CYOcupaDes	VARCHAR(100);	-- Conyugue Descripcion Ocupacion
    DECLARE Var_CYDirecAc   VARCHAR(100);
	DECLARE Var_CYEmpLab	VARCHAR(100);	-- Conyugue Empresa Labora
	DECLARE Var_CYFechaNac	DATE;			-- Conyugue Fecha Nacimiento

    DECLARE Var_CYCalle		VARCHAR(100);	-- Conyugue Calle
    DECLARE Var_CYEstadoNac	INT(11);		-- Conyugue Estado
    DECLARE Var_CYEdoNacDes	VARCHAR(100);	-- Conyugue Descripcion Estado
	DECLARE Var_CYTelTrab	VARCHAR(16);	-- Conyugue Telefono Trabajo
	DECLARE Var_CYPaisNac	INT(11);		-- Conyugue Pais

    DECLARE Var_CYPaisDes	VARCHAR(100);	-- Conyugue Descripcion PAis
    DECLARE Var_CYAntigued	CHAR(10);		-- Conyugue Antiguedad
	DECLARE Var_CYNacion	CHAR(1);		-- Conyugue Nacionalidad
    DECLARE Var_CYNacionDes	VARCHAR(100);	-- Conyugue Descripcion Nacionalidad
    DECLARE Var_CYNacionN	CHAR(1);		-- Conyugue Nacional

    DECLARE Var_CYNacionE	CHAR(1);		-- Conyugue Extranjera
    DECLARE Var_CYNacionNAC	VARCHAR(100);	-- Conyugue Descripcion Nacional
    DECLARE Var_CYNacionEXT	VARCHAR(100);	-- Conyugue Descripcion Extranjera
	DECLARE Var_CYTelCel	VARCHAR(16);	-- Conyugue Telefono
    DECLARE Var_FechaActual	DATE;			-- Fecha Actual

    DECLARE Var_CYEdad		INT(5);			-- Edad del Cliente
    DECLARE Var_NumHijos	INT(4);			-- Numero Hijos
    DECLARE Var_NumDepen	INT(4);			-- Numero Dependientes
    DECLARE Var_GarantID	INT(11);		-- Garantia
    DECLARE Var_GarantDes	VARCHAR(100);	-- Descripcion Garantia

    DECLARE Var_Pres		VARCHAR(100);	-- Presidente
    DECLARE Var_Secre		VARCHAR(100);	-- Secretario
    DECLARE Var_Teso		VARCHAR(100);	-- Tesorero
    DECLARE Var_RLRelID		INT(11);		-- Rep Legal Relacion
    DECLARE Var_RLNomCom	VARCHAR(200);	-- Rep Legal Nombre Completo

    DECLARE Var_RLDomCasa	VARCHAR(500);	-- Rep Legal Casa
	DECLARE Var_RLEstadoID	INT(11);		-- Rep Legal Estado
    DECLARE Var_RLEstadoDes	VARCHAR(100);	-- Rep Legal Descripcion Estado
	DECLARE Var_RLPais		INT(11);		-- Rep Legal Pais
    DECLARE Var_RLPaisDes	VARCHAR(100);	-- Rep Legal Descripcion Pais

    DECLARE Var_RLFecNac	DATE;			-- Rep Legal Fecha Nacimeinto
    DECLARE Var_RLNacion	CHAR(1);		-- Rep Legal Nacionalidad
    DECLARE Var_RLNacDes	VARCHAR(100);	-- Rep Legal Descripcion Nacionalidad
    DECLARE Var_RLOcupID	INT(11);		-- Rep Legal Ocupacion
    DECLARE Var_RLOcupDes	VARCHAR(100);	-- Rep Legal Descripcion Ocupacion

	DECLARE Var_RLTel		VARCHAR(20);	-- Rep Legal Telefono
    DECLARE	Var_RLEdad		INT(4);			-- Rep Legal Edad
    DECLARE Var_RLConyNom	VARCHAR(300);	-- Rep Legal Conyugue Nombre
    DECLARE Var_RLNumDepen	INT(4);			-- Rep Legal Numero Dependientes
    DECLARE Var_RLCred		BIGINT(12);		-- Rep Legal Credito

    DECLARE Var_RLCuantas	INT(11);		-- Rep Legal Cuantos Credito
    DECLARE Var_RLConCred	CHAR(1);		-- Rep Legal Con Credito
    DECLARE ContarCredN		CHAR(1);		-- Rep Legal Cuenta Credito Si
    DECLARE ContarCredS		CHAR(1);		-- Rep Legal Cuenta Credito No
    DECLARE Var_RLTipPer	CHAR(1);		-- Rep Legal Tipo Persona

    DECLARE Var_RLTipPerDes	VARCHAR(100);	-- Rep Legal Descripcion Tipo Persona
    DECLARE Var_RLTipPerF	CHAR(1);		-- Rep Legal Tipo Persona Fisica
    DECLARE Var_RLTipPerM	CHAR(1);		-- Rep Legal Tipo Persona Moral
    DECLARE Var_RLTipPerA	CHAR(1);		-- Rep Legal Tipo Persona Actividad Empresarial
    DECLARE Var_RLPerFDes	VARCHAR(100);	-- Rep Legal Descripcion Tipo Persona Fisica

    DECLARE Var_RLPerMDes	VARCHAR(100);	-- Rep Legal Descripcion Tipo Persona Moral
    DECLARE Var_RLPerADes	VARCHAR(100);	-- Rep Legal Descripcion Tipo Persona Actividad Empresarial
    DECLARE Var_RLCuaDes	CHAR(1);		-- Rep Legal Representa a Otra Persona
    DECLARE Var_RLCliRS		VARCHAR(150);	-- Rep Legal Razon Social Persona
    DECLARE Var_RLAccion	CHAR(1);		-- Rep Legal Es Accionista

    DECLARE Var_RLAccPor	DECIMAL(12,4);	-- Rep Legal Porcentaje Acciones
    DECLARE Var_RLCliOtro	INT(11);		-- Rep Legal Cliente Otro

    DECLARE Var_GarHipID    INT(11);        -- Garante ID                        NUEVO
    DECLARE Var_GarHipNom   VARCHAR(200);   -- Garante Nombre Completo           NUEVO
    DECLARE Var_GarHipDir   VARCHAR(200);   -- Garante Direccion                 NUEVO
    DECLARE Var_GarHipTel   VARCHAR(20);    -- Garante Telefono                  NUEVO
    DECLARE Var_GarHipRel   INT(11);        -- Garante Tipo Relacion             NUEVO
    DECLARE Var_GarHipRelDe VARCHAR(100);   -- Garante Descripcion Tipo Relacion NUEVO

    DECLARE Var_Inicial		INT(11);		-- Ciclo Inicial
    DECLARE Var_CountAval	INT(11);		-- Cuantos Avales
    DECLARE Var_AvalID		INT(11);		-- Aval ID

    DECLARE Var_AvNomComp	VARCHAR(200);	-- Aval Nombre Completo
    DECLARE Var_CountDatSoc	INT(11);		-- Cuantos Datos SocioEconomicos
    DECLARE Var_CatSoc		INT(11);		-- ID Dato SocioEconomico
    DECLARE Var_DTIngreso   DECIMAL(14,2);
    DECLARE Var_DTGasto     DECIMAL(14,2);
    DECLARE Var_Excedente   DECIMAL(14,2);
    DECLARE Var_CatSocMon	DECIMAL(14,2);	-- Monto Dato SocioEconomico
    DECLARE Var_CatSocDes	VARCHAR(100);	-- Descripcion Dato SocioEconomico
    DECLARE Var_CatSocTipo  CHAR(1);    
    DECLARE EsIngreso       CHAR(1);
    DECLARE EsGasto         CHAR(1);    

    DECLARE Var_CountAhoVis INT(11);		-- Cuantos Ahorro Vista
    DECLARE Var_CuentaID	BIGINT(20);		-- Cuenta Ahorro ID
    DECLARE Var_SaldoDispon	DECIMAL(12,2);	-- Saldo Disponible
    DECLARE Var_AVDirCom	VARCHAR(200);	-- Aval Direccion
    DECLARE Var_AVTelefono	VARCHAR(20);	-- Aval Telefono

    DECLARE Var_AVTipRel	INT(11);		-- Aval Tipo Relacion
    DECLARE Var_AVTipRelDes	VARCHAR(100);	-- Aval Descripcion Tipo Relacion
    DECLARE Var_CountInver	INT(11);		-- Cuentas Inversiones
    DECLARE Var_InversionID	INT(11);		-- ID Inversion
    DECLARE Var_Mont		DECIMAL(14,2);	-- Monto Inversion

    DECLARE Var_FechaIni	DATE;			-- Fecha Inicio
    DECLARE Var_FechaVenci	DATE;			-- Fecha Vencimiento
    DECLARE Var_CountDirec	INT(11);		-- Cuantos Directivos
    DECLARE Var_DirNomCom	VARCHAR(100);	-- Directivo Nombre Completo
    DECLARE Var_DirPorcAcc	DECIMAL(12,4);	-- Directivo Porcentaje Acciones

    DECLARE Var_CountRL		INT(11);		-- Cuantos Representante Legal
    DECLARE Var_PFNomCom	VARCHAR(200);	-- Persona Firmante Nombre Completo
    DECLARE Var_PFInsEspec	VARCHAR(150);	-- Persona Firmante Instruccion Especial
    DECLARE Var_PACalle		VARCHAR(200);	-- Aval Calle
    DECLARE Var_PAColonia	VARCHAR(200);	-- Aval Colonia

    DECLARE Var_PALocID		INT(11);		-- Aval Localidad
    DECLARE Var_PAMunID		INT(11);		-- Aval Municipio
    DECLARE Var_PAEdoID		INT(11);		-- Aval Estado
    DECLARE Var_PALugNac	INT(11);		-- Aval Pais
    DECLARE Var_PALocIDDes	VARCHAR(100);	-- Aval Descripcion Localidad

    DECLARE Var_PAMunIDDes	VARCHAR(100);	-- Aval Descripcion Municipio
    DECLARE Var_PAEdoIDDes	VARCHAR(100);	-- Aval Descripcion Estado
    DECLARE Var_PAPaisNom	VARCHAR(100);	-- Aval Descripcion Pais
    DECLARE Var_PACP		VARCHAR(5);		-- Aval CP
    DECLARE Var_SucuID		INT(11);		-- Sucursal ID
    
-- DECLARACION DE LLAVES PARAMETRO
    DECLARE TipoOpe     VARCHAR(20);    
    DECLARE ClaSegVid   VARCHAR(30);
    DECLARE SeguroDan   VARCHAR(20);
    DECLARE ClaSegDa    VARCHAR(30);
    -- numCon 1
    DECLARE Aseguradora	VARCHAR(50);	-- Llave Parametro Aseguradora      NUEVO
    DECLARE MontoAmpSV  VARCHAR(20);    -- Llave Parametro Monto amparado   NUEVO
    DECLARE NumPoliza 	VARCHAR(50);	-- Llave Parametro Numero de Poliza NUEVO   
    DECLARE VigInicioSV VARCHAR(20);    -- Llave Parametro Vigencia inicio  NUEVO
    DECLARE CoberturaSV VARCHAR(20);    -- Llave Parametro Cobertura        NUEVO
    DECLARE VigFinSV    VARCHAR(20);    -- Llave Parametro Vigencia fin     NUEVO

    DECLARE ValorCom	VARCHAR(20);	-- Llave Parametro Valor Comercial
    DECLARE GarantID	VARCHAR(20);	-- Llave Parametro Garantia
    DECLARE MonAvaluo	VARCHAR(20);	-- Llave Parametro Monto Avaluo
    DECLARE FecVerif	VARCHAR(20);	-- Llave Parametro Fecha Verificacion
    DECLARE TipPiso		VARCHAR(30);	-- Llave Parametro Tipo Piso

    DECLARE FechaFin	VARCHAR(20);	-- Llave Parametro Fecha Final
    DECLARE NomVal		VARCHAR(20);	-- Llave Parametro Nombre Valuador
    DECLARE NumeAvaluo	VARCHAR(20);	-- Llave Parametro Numero Avaluo
    DECLARE FecValua	VARCHAR(20);	-- Llave Parametro Fecha Valuacion
    DECLARE MonGarLiq	VARCHAR(20);	-- Llave Parametro Monto Garantia Liquida

    DECLARE CtaAhoID	VARCHAR(20);	-- Llave Parametro Cuenta Ahorro
    DECLARE AvNomComp	VARCHAR(30);	-- Llave Parametro Aval Nombre Completo
    DECLARE SoliCredID	VARCHAR(20);	-- Llave Parametro Solicitud Credito
    DECLARE SucurDes	VARCHAR(20);	-- Llave Parametro Descripcion Sucursal
    DECLARE ClienID		VARCHAR(20);	-- Llave Parametro Cliente ID

    DECLARE ProspecID	VARCHAR(20);	-- Llave Parametro Prospecto ID
    DECLARE MontoSoli	VARCHAR(20);	-- Llave Parametro Monto Solicitado
    DECLARE DestCreDes	VARCHAR(20);	-- Llave Parametro Destino Credito
    DECLARE ProdCredDes	VARCHAR(20);	-- Llave Parametro Producto Credito
    DECLARE PlazoDes	VARCHAR(20);	-- Llave Parametro Plazo

    DECLARE TasFij		VARCHAR(20);	-- Llave Parametro Tasa Fija
    DECLARE FrecCapDes	VARCHAR(20);	-- Llave Parametro Frecuencia Capital
    DECLARE MonedaDes	VARCHAR(20);	-- Llave Parametro Moneda
    DECLARE Esta		VARCHAR(20);	-- Llave Parametro Estatus
    
    -- numCon 6
    DECLARE FecAutORech	VARCHAR(20);	-- Llave Parametro Fecha Autorizacion Rechazo
    DECLARE ResAut      VARCHAR(20);     -- Llave Parametro Resolucion Aprobada NUEVO
    DECLARE ResRech     VARCHAR(20);     -- Llave Parametro Resolucion Rechazada NUEVO

    DECLARE PromNombre	VARCHAR(20);	-- Llave Parametro Promotor Nombre
    DECLARE GradoEscDes	VARCHAR(20);	-- Llave Parametro Grado Escolar
    DECLARE TipoMatDes	VARCHAR(30);	-- Llave Parametro Tipo Material
    DECLARE ValorVivi	VARCHAR(30);	-- Llave Parametro Valor Vivienda
    DECLARE CYPriNombre	VARCHAR(30);	-- Llave Parametro Conyugue Nombre

    DECLARE CYOcupaDes	VARCHAR(30);	-- Llave Parametro Conyugue Ocupacion

    DECLARE CYDirecAc	VARCHAR(30);
    DECLARE CYEmpLab	VARCHAR(30);	-- Llave Parametro Conyugue Empresa Labora
    DECLARE CYFechaNac	VARCHAR(30);	-- Llave Parametro Conyugue Fecha Nacimiento
    DECLARE CYCalle		VARCHAR(30);	-- Llave Parametro Conyugue Calle
    DECLARE CYEdoNacDes	VARCHAR(30);	-- Llave Parametro Conyugue Estado

    DECLARE CYTelTrab		VARCHAR(30);	-- Llave Parametro Conyugue Telefono Trabajo
    DECLARE CYPaisDes		VARCHAR(30);	-- Llave Parametro Conyugue Pais
    DECLARE CYAntiguedad	VARCHAR(30);	-- Llave Parametro Conyugue Antiguedad
    DECLARE CYNacionDes		VARCHAR(30);	-- Llave Parametro Conyugue Nacionalidad
    DECLARE CYTelCel		VARCHAR(30);	-- Llave Parametro Conyugue Telefono

    DECLARE CYEdad		VARCHAR(30);	-- Llave Parametro Conyugue Edad
    DECLARE NumHijos	VARCHAR(20);	-- Llave Parametro Numero Hijos
    DECLARE NumDepen	VARCHAR(20);	-- Llave Parametro Numero Dependientes
    DECLARE GarantDes	VARCHAR(20);	-- Llave Parametro Garantia
    DECLARE DT			VARCHAR(20);	-- Llave Parametro Dato Socio
    DECLARE DTIngreso   VARCHAR(30);
    DECLARE DTGasto     VARCHAR(30);
    DECLARE Excedente   VARCHAR(20);

    DECLARE CAVC	VARCHAR(30);	-- Llave Parametro Cuenta Ahorro
    DECLARE CAVM	VARCHAR(30);	-- Llave Parametro Monto Ahorro
    DECLARE InvI	VARCHAR(30);	-- Llave Parametro Inversion ID
    DECLARE InvM	VARCHAR(30);	-- Llave Parametro Inversion Monto
    DECLARE InvF	VARCHAR(30);	-- Llave Parametro Inversion Fecha Inicio

    DECLARE InvV		VARCHAR(30);	-- Llave Parametro Inversion Fecha Vencimiento
    DECLARE AVDirCom	VARCHAR(30);	-- Llave Parametro Aval Direccion
    DECLARE AVTelefono	VARCHAR(30);	-- Llave Parametro Aval Telefono
    DECLARE AVTipRelDes	VARCHAR(30);	-- Llave Parametro Aval Tipo Relacion
    DECLARE Pres		VARCHAR(20);	-- Llave Parametro Presidente

    DECLARE Secre		VARCHAR(20);	-- Llave Parametro Secretario
    DECLARE Teso		VARCHAR(20);	-- Llave Parametro Tesorero
    DECLARE RLNomCom	VARCHAR(30);	-- Llave Parametro Rep Legal Nombre Completo
    DECLARE RLDomCasa	VARCHAR(30);	-- Llave Parametro Rep Legal Domicilio
    DECLARE RLFecNac	VARCHAR(30);	-- Llave Parametro Rep Legal Fecha Nacimiento

    DECLARE RLEstadoDes	VARCHAR(30);	-- Llave Parametro Rep Legal Estado
    DECLARE RLPaisDes	VARCHAR(30);	-- Llave Parametro Rep Legal Pais
    DECLARE RLEdad		VARCHAR(30);	-- Llave Parametro Rep Legal Edad
    DECLARE RLNacDes	VARCHAR(30);	-- Llave Parametro Rep Legal Nacionalidad
    DECLARE RLOcupDes	VARCHAR(30);	-- Llave Parametro Rep Legal Ocupacion

    DECLARE RLTel		VARCHAR(30);	-- Llave Parametro Rep Legal Telefono
    DECLARE RLConyNom	VARCHAR(30);	-- Llave Parametro Rep Legal Conyugue Nombre
    DECLARE RLNumDepen	VARCHAR(30);	-- Llave Parametro Rep Legal Numero Dependientes
    DECLARE RLConCred	VARCHAR(30);	-- Llave Parametro Rep Legal Tiene Credito
    DECLARE RLTipPerDes	VARCHAR(30);	-- Llave Parametro Rep Legal Tipo Persona

    DECLARE RLCuaDes	VARCHAR(30);	-- Llave Parametro Rep Legal Representa Otra
    DECLARE RLCliRS		VARCHAR(30);	-- Llave Parametro Rep Legal Razon Social
    DECLARE RLAccion	VARCHAR(30);	-- Llave Parametro Rep Legal Es Accionista
    DECLARE RLAccPor	VARCHAR(30);	-- Llave Parametro Rep Legal Porcentaje Acciones

    DECLARE GarHipNom   VARCHAR(30);   -- Llave Parametro Garante Nombre            NUEVO
    DECLARE GarHipDir   VARCHAR(30);   -- Llave Parametro Garante Direccion         NUEVO
    DECLARE GarHipTel   VARCHAR(30);   -- Llave Parametro Garante Telefono          NUEVO
    DECLARE GarHipRelDe VARCHAR(30);   -- Llave Parametro Garante Relacion          NUEVO

    DECLARE SocAc		VARCHAR(20);	-- Llave Parametro Socio Accionista
    DECLARE SocAcP	VARCHAR(20);	-- Llave Parametro Socio Porcentaje
    DECLARE PodFacN	VARCHAR(20);	-- Llave Parametro Poderes Nombre
    DECLARE PodFacI	VARCHAR(20);	-- Llave Parametro Poderes Instruccion
    DECLARE DiaMes	VARCHAR(20);	-- Llave Parametro Dia Mes
    DECLARE AVCalle	VARCHAR(30);	-- Llave Parametro Aval Calle

    DECLARE AVColonia	VARCHAR(30);	-- Llave Parametro Aval Colonia
    DECLARE AVLoc		VARCHAR(30);	-- Llave Parametro Aval Localidad
    DECLARE AVMun		VARCHAR(30);	-- Llave Parametro Aval Municipio
    DECLARE AVEdo		VARCHAR(30);	-- Llave Parametro Aval Estado
    DECLARE AVPais		VARCHAR(30);	-- Llave Parametro Aval Pais

    DECLARE AVCP		VARCHAR(30);	-- Llave Parametro Aval CP
    DECLARE MunIDDes	VARCHAR(20);	-- Llave Parametro Sucursal Municipio
    DECLARE EdoIDDes	VARCHAR(20);	-- Llave Parametro Sucursal Estado
    DECLARE SucDirec	VARCHAR(20);	-- Llave Parametro Sucursal Direccion
        
    DECLARE Transaccion	BIGINT(20);		-- Transaccion

-- ASIGNACION DE CONSTANTES
    SET	Cadena_Vacia	:= '';
	SET	Fecha_Vacia		:= '1900-01-01';
	SET	Entero_Cero		:= 0;
    SET Entero_Uno		:= 1;
	SET Entero_Dos		:= 2;
    SET Entero_Tres		:= 3;
    SET Decimal_Cero	:= 0.00;
    SET NOENCONTRADO	:= 'NO ENCONTRADO';

    SET Con_SegA	:= 1;	-- VALOR DEL REPORTE RECA ANEXO A
    SET Con_SegB	:= 2;	-- VALOR DEL REPORTE RECA ANEXO B
    SET Con_SegC	:= 3;	-- VALOR DEL REPORTE RECA ANEXO C
    SET Con_SegD	:= 4;	-- VALOR DEL REPORTE RECA CONTRATO APERTURA DE CREDITO AViO AGROPECUARIO
    SET Con_SegE	:= 5;	-- VALOR DEL REPORTE RECA PRECEPTOS LEGALES

    SET Con_SegF	:= 6;	-- VALOR DEL REPORTE RECA SOLICITUD DE CREDITO DE PERSONA FISICA
    SET Con_SegG	:= 7;	-- VALOR DEL REPORTE RECA SOLICITUD DE CREDITO DE PERSONA MORAL
    SET Con_SegH	:= 8;	-- VALOR DEL REPORTE AUTORIZACION DE CARGO AUTOMATICO
    SET Con_SegI	:= 9;	-- VALOR DEL REPORTE CESION DE DERECHOS
    SET Con_SegJ	:= 10;	-- VALOR DEL REPORTE DECLARATORIA DUD

    SET Con_SegK	:= 11;	-- VALOR DEL REPORTE PAGARE PAGO UNICO INTERES MENSUALDUD
    SET Con_SegL	:= 12;	-- VALOR DEL REPORTE PAGARE PAGO UNICO
    SET Con_SegM	:= 13;	-- VALOR DEL REPORTE PAGOS ADELANTADOS OK

    SET EsIngreso   := 'I';
    SET EsGasto     := 'E';  
    SET EstCuenA	:= 'A';
    SET EstInvN		:= 'N';
    SET FrecCapS	:= 'S';
    SET FrecCapC	:= 'C';
    SET FrecCapQ	:= 'Q';
    SET FrecCapM	:= 'M';
    SET FrecCapP	:= 'P';

    SET FrecCapB	:= 'B';
    SET FrecCapT	:= 'T';
    SET FrecCapR	:= 'R';
    SET FrecCapE	:= 'E';
    SET FrecCapA	:= 'A';

    SET FrecCapL	:= 'L';
    SET FrecCapU	:= 'U';
    SET FrecCapD	:= 'D';
    SET FrecCapSDes	:= 'SEMANAL';
    SET FrecCapCDes	:= 'CATORCENAL';

    SET FrecCapQDes	:= 'QUINCENAL';
    SET FrecCapMDes	:= 'MENSUAL';
    SET FrecCapPDes	:= 'PERIODO';
    SET FrecCapBDes	:= 'BIMESTRAL';
    SET FrecCapTDes	:= 'TRIMESTRAL';

    SET FrecCapRDes	:= 'TETRAMESTRAL';
    SET FrecCapEDes	:= 'SEMESTRAL';
    SET FrecCapADes	:= 'ANUAL';
    SET FrecCapLDes	:= 'LIBRES';
    SET FrecCapUDes	:= 'PAGO UNICO';

    SET FrecCapDDes		:= 'DECENAL';
    SET Var_CYNacionN	:= 'N';
    SET Var_CYNacionE	:= 'S';
    SET Var_CYNacionNAC	:= 'NACIONAL';
    SET Var_CYNacionEXT	:= 'EXTRANJERA';

    SET Var_FechaActual := NOW();
    SET ContarCredN		:= 'N';
    SET ContarCredS		:= 'S';
    SET Var_RLTipPerF	:= 'F';
    SET Var_RLTipPerM	:= 'M';

    SET Var_RLTipPerA	:= 'A';
    SET Var_RLPerFDes	:= 'FISICA';
    SET Var_RLPerMDes	:= 'MORAL';
    SET Var_RLPerADes	:= 'FISICA CON ACTIVIDAD EMPRESARIAL';
    
    SET Var_TipoOpe     := 'ACTIVA';
    SET Var_ClaSegVid   := 'Vigesima Sexta';
    SET Var_SeguroDan   := Decimal_Cero;
    SET Var_ClaSegDa    := 'Vigesima Septima';

-- VARIABLES USADAS EN LOS NUMCON's DEL WS
    -- VARIABLES SIN USO APARENTE
    SET InvI	:= 'investmentNumber';
    SET InvM	:= 'investmentAmount';
    SET InvF	:= 'investmentStartDate';
    SET InvV	:= 'investmentEndDate';

    SET SocAc		:=	'partnerName';
    SET SocAcP		:=	'partnerPercent';
    SET PodFacN		:=	'legalRepName';
    SET PodFacI		:=	'legalRepFaculty';

-- ASIGNACION DE LLAVES PARAMETRO
    SET TipoOpe     := 'operationType';
    SET ClaSegVid   := 'lifeInsuranceClause';
    SET SeguroDan   := 'damageInsurance';
    SET ClaSegDa    := 'damageInsuranceClause';
    -- numCon 1
	SET Aseguradora	:=	'insuranceCarrier';     -- NUEVO
    SET MontoAmpSV  :=  'insuranceAmount';      -- NUEVO
    SET NumPoliza   :=  'numPolicy';            -- NUEVO
    SET VigInicioSV :=  'startValidity';        -- NUEVO
    SET CoberturaSV :=  'coverage';             -- NUEVO
    SET VigFinSV    :=  'endValidity';          -- NUEVO
    -- numCon 3
    SET ValorCom	:= 'commercialValue';
    SET GarantID	:= 'warrantyNumber';
    SET MonAvaluo	:= 'appraisedAmount';
    SET FecVerif	:= 'verificationDate';
    SET TipPiso		:= 'warrantyClasification';
    SET FechaFin	:= 'finalDate';
    SET NomVal		:= 'appraiserName';
    SET NumeAvaluo	:= 'appraisedNumber';
    SET FecValua	:= 'valuationDate';
    SET MonGarLiq	:= 'warrantyAmount'; 
    SET CtaAhoID	:= 'savingAccount';
    -- numCon 4
    SET MunIDDes	:= 'municipalityRequest';
    SET EdoIDDes	:= 'stateRequest';
    SET AvNomComp	:= 'guaranteeName';
    -- numCon 6
    SET SoliCredID	    := 'creditRequestNumber';
    SET SucurDes	    := 'subsidiary';
    SET ClienID		    := 'customerNumber';
    SET ProspecID	    := 'prospectNumber';
    SET MontoSoli	    := 'requestAmount';
    SET DestCreDes	    := 'creditPurpose';
    SET ProdCredDes	    := 'creditProduct';
    SET PlazoDes	    := 'term';
    SET TasFij	    	:= 'fixedRate';
    SET FrecCapDes	    := 'capitalFrecuency';
    SET MonedaDes	    := 'coin';
    SET Esta		    := 'status';
    SET FecAutORech	    := 'resolutionDate';
    SET ResAut          := 'approvedResolution'; -- NUEVO
    SET ResRech         := 'rejectedResolution'; -- NUEVO
    SET PromNombre	    := 'promotorName';
    SET GradoEscDes	    := 'schoolGrade';
    SET TipoMatDes	    := 'materialType';
    SET ValorVivi	    := 'homeValue';
    SET CYPriNombre	    := 'coupleFullName';
    SET CYOcupaDes	    := 'coupleOccupation';
    SET CYDirecAc       := 'coupleCurrentDirection';
    SET CYEmpLab	    := 'coupleWorkplace';
    SET CYFechaNac	    := 'coupleBirthDate';
    SET CYCalle		    := 'coupleDirection';
    SET CYEdoNacDes	    := 'coupleBirthState';
    SET CYTelTrab	    := 'coupleWorkTelephone';
    SET CYPaisDes	    := 'coupleCountry';
    SET CYAntiguedad    := 'coupleWorkSeniority';
    SET CYNacionDes	    := 'coupleNationality';
    SET CYTelCel	    := 'coupleCellphone';
    SET CYEdad		    := 'coupleAge';
    SET NumHijos	    := 'numChildren';
    SET NumDepen	    := 'numDependents';
    SET GarantDes	    := 'warrantyType';
    SET DT			    := 'partnerData';
    SET DTIngreso		:= 'partnerDataIncomes';
    SET DTGasto		    := 'partnerDataExpenses';
    SET Excedente       := 'surplus';
    SET CAVC		    := 'savingAccount';
    SET CAVM	        := 'amountInAccount';
    SET GarHipNom       := 'guarantorName';         -- NUEVO
    SET GarHipDir       := 'guarantorDirection';    -- NUEVO
    SET GarHipTel       := 'guarantorTelephone';    -- NUEVO
    SET GarHipRelDe     := 'guarantorRelation';     -- NUEVO
    SET AVDirCom	    := 'guaranteeDirection';
    SET AVTelefono	    := 'guaranteeTelephone';
    SET AVTipRelDes	    := 'guaranteeRelation';
    -- numCon 7
    SET Pres		    := 'president';
    SET Secre		    := 'secretary';
    SET Teso		    := 'treasurer';
    SET RLNomCom	    := 'legalRepFullName';
    SET RLDomCasa	    := 'legalRepDirection';
	SET RLFecNac	    := 'legalRepBirthDate';
    SET RLEstadoDes	    := 'legalRepState';
    SET RLPaisDes	    := 'legalRepCountry';
    SET RLEdad		    := 'legalRepAge';
    SET RLNacDes	    := 'legalRepNationality';
    SET RLOcupDes	    := 'legalRepOccupation';
    SET RLTel		    := 'legalRepTelephone';
    SET RLConyNom	    := 'legalRepCoupleName';
    SET RLNumDepen	    := 'legalRepDependents';
    SET RLConCred	    := 'legalRepHaveCredit';
    SET RLTipPerDes	    := 'legalRepPersonType';
    SET RLCuaDes	    := 'legalRepPersonRep';
    SET RLCliRS		    := 'legalRepBussinessName';
    SET RLAccion	    := 'legalRepShareholder';
    SET RLAccPor	    := 'legalRepShareholderPercent';    
    -- num 11
    SET DiaMes		:= 'dayOfMonth';
    SET SucDirec	:= 'subsidiaryDirection';
    SET AVCalle		:= 'guaranteeStreet';
    SET AVColonia	:= 'guaranteeSuburb';
    SET AVLoc	    := 'guaranteeLocality';
    SET AVMun	    := 'guaranteeMunicipality';
    SET AVEdo	    := 'guaranteeState';
    SET AVPais	    := 'guaranteeCountry';
    SET AVCP	    := 'guaranteeZipCode';
    


-- CONSULTAS EN WS
	-- numCon 1, 3 - insuranceCarrier NUEVO
    IF (Par_NumCon = Con_SegA || Par_NumCon = Con_SegC) THEN
		SET Var_ClienteID	:= (SELECT ClienteID FROM SOLICITUDCREDITO WHERE SolicitudCreditoID = Par_SolCredID);
		SET Var_GarantID	:= IFNULL((SELECT GarantiaID FROM GARANTIAS WHERE ClienteID = Var_ClienteID AND TipoGarantiaID = Entero_Tres LIMIT Entero_Uno), Entero_Cero);
        
        SELECT  Asegurador
		INTO	Var_Aseguradora
		FROM 	GARANTIAS
		WHERE 	GarantiaID = Var_GarantID
		LIMIT 1;

	SET Var_Aseguradora	:= IFNULL(Var_Aseguradora, Cadena_Vacia);
    END IF;
    
    -- numCon 1, 2, 3 - insuranceAmount NUEVO
	IF (Par_NumCon = Con_SegA || Par_NumCon = Con_SegB || Par_NumCon = Con_SegC) THEN
        SET Var_MontoAmpSV := IFNULL((SELECT MontoPoliza FROM SEGUROVIDA WHERE CLIENTEID = Var_ClienteID LIMIT 1), Decimal_Cero);
    END IF;

	-- numCon 2 - coin
    IF (Par_NumCon = Con_SegB) THEN
		SELECT	MonedaID
        INTO	Var_MonedaID
        FROM	SOLICITUDCREDITO
		WHERE	SolicitudCreditoID = Par_SolCredID;
		
        SET Var_MonedaDes	:= IFNULL((SELECT Descripcion FROM MONEDAS WHERE MonedaId = Var_MonedaID), Cadena_Vacia);
    END IF;
    
    -- numCon 3 - startValidity, endValidity
    IF (Par_NumCon = Con_SegC) THEN
        SET Var_NumPoliza   := IFNULL((SELECT NumPoliza FROM GARANTIAS WHERE ClienteID = Var_ClienteID LIMIT 1), Entero_Cero);
        SET Var_VigInicioSV := IFNULL((SELECT FechaInicio FROM SEGUROVIDA WHERE ClienteID = Var_ClienteID LIMIT 1), Fecha_Vacia);
        SET Var_CoberturaSV := '';
        SET Var_VigFinSV    := IFNULL((SELECT FechaVencimiento FROM SEGUROVIDA WHERE ClienteID = Var_ClienteID LIMIT 1), Fecha_Vacia);
    END IF;
	
    -- numCon 3 - warrantyNumber, warrantyClasification, warranryAmount, savingAccount, commercialValue
    --            appraisedAmount, verificationDate, finalDate, appraiserName, appraisedNumber, valuationDate
    IF (Par_NumCon = Con_SegC) THEN
		SET Var_ClienteID	:= (SELECT ClienteID FROM SOLICITUDCREDITO WHERE SolicitudCreditoID = Par_SolCredID);
		SET Var_GarantID	:= IFNULL((SELECT GarantiaID FROM GARANTIAS WHERE ClienteID = Var_ClienteID AND TipoGarantiaID = Entero_Tres LIMIT Entero_Uno), Entero_Cero);

		SELECT  ValorComercial,	MontoAvaluo,	FechaVerificacion,	ClasifGarantiaID,	TipoGarantiaID,
				DATE_ADD(FechaVerificacion, INTERVAL 10 YEAR),
				NombreValuador,	NumAvaluo,		FechaValuacion,		NumPoliza,			ClienteID
		INTO	Var_ValorCom,	Var_MonAvaluo,	Var_FecVerif,		Var_ClasGarID,		Var_TipGarID,
				Var_FechaFin,
                Var_NomVal,		Var_NumAvaluo,	Var_FecValua,		Var_NumPoliza,			Var_ClienteID
		FROM GARANTIAS
			WHERE GarantiaID = Var_GarantID
			LIMIT 1;

		SET Var_TipoPiso	:= IFNULL((SELECT Descripcion FROM CLASIFGARANTIAS WHERE ClasifGarantiaID = Var_ClasGarID AND TipoGarantiaID =Var_TipGarID LIMIT 1), Cadena_Vacia);
        SET Var_MontoGarLiq	:= IFNULL((SELECT MontoGarLiq FROM DETALLEGARLIQUIDA WHERE SolicitudCreditoID = Par_SolCredID), Decimal_Cero);
        SET Var_CuentaAhoID	:= IFNULL((SELECT CuentaAhoID FROM CUENTASAHO WHERE ClienteID = Var_ClienteID AND EsPrincipal = FrecCapS), Entero_Cero);
		SET Var_ValorCom	:= IFNULL(Var_ValorCom, Decimal_Cero);
		SET Var_MonAvaluo	:= IFNULL(Var_MonAvaluo, Decimal_Cero);
		SET Var_FecVerif	:= IFNULL(Var_FecVerif, Fecha_Vacia);
		SET Var_FechaFin	:= IFNULL(Var_FechaFin, Fecha_Vacia);
		SET Var_NomVal		:= IFNULL(Var_NomVal, Cadena_Vacia);
		SET Var_NumAvaluo	:= IFNULL(Var_NumAvaluo, Cadena_Vacia);
		SET Var_FecValua	:= IFNULL(Var_FecValua, Fecha_Vacia);
        SET Var_NumPoliza	:= IFNULL(Var_NumPoliza, Entero_Cero);
    END IF;
    
    IF (Par_NumCon = Con_SegC) THEN
        SET Var_AvalID		:= IFNULL((SELECT AvalID FROM AVALESPORSOLICI WHERE SolicitudCreditoID = Par_SolCredID LIMIT 1), Entero_Cero);
		SET Var_AvNomComp	:= IFNULL((SELECT NombreCompleto FROM AVALES WHERE AvalID = Var_AvalID), Cadena_Vacia);
    END IF;
    -- numCon 4, 11, 12 - subsidiaryNumber, StateNumber, subsidiaryDirection, municipalityRequest
    IF (Par_NumCon = Con_SegD	|| Par_NumCon = Con_SegK	|| Par_NumCon = Con_SegL) THEN
		SET	Var_SucuID	:= IFNULL((SELECT SucursalID FROM SOLICITUDCREDITO WHERE SolicitudCreditoID = Par_SolCredID), Entero_Cero);
		
        SELECT	MunicipioID,		EstadoID,		DirecCompleta
        INTO	Var_MunicipioID,	Var_EstadoID,	Var_SucDirec
        FROM SUCURSALES
		WHERE SucursalID = Var_SucuID;

        SET Var_MunIDDes	:= IFNULL((SELECT Nombre FROM MUNICIPIOSREPUB WHERE MunicipioID = Var_MunicipioID AND EstadoID = Var_EstadoID), Cadena_Vacia);
        SET Var_EdoIDDes	:= IFNULL((SELECT Nombre FROM ESTADOSREPUB WHERE EstadoID = Var_EstadoID), Cadena_Vacia);
        SET	Var_SucDirec	:= IFNULL(Var_SucDirec, Cadena_Vacia);
    END IF;

    -- numCon 5, 6 - 
    IF (Par_NumCon = Con_SegF || Par_NumCon = Con_SegG) THEN
	    SET Var_ClienteID	:= (SELECT ClienteID FROM SOLICITUDCREDITO WHERE SolicitudCreditoID = Par_SolCredID);
		SET Var_GarantID	:= IFNULL((SELECT GarantiaID FROM GARANTIAS WHERE ClienteID = Var_ClienteID AND TipoGarantiaID = Entero_Tres LIMIT Entero_Uno), Entero_Cero);
        SET Var_GarHipID    := IFNULL((SELECT GaranteID FROM GARANTIAS WHERE GarantiaID = Var_GarantID LIMIT Entero_Uno), Entero_Cero);
   
        SELECT  NombreCompleto, DireccionCompleta, Telefono
		INTO	Var_GarHipNom, Var_GarHipDir, Var_GarHipTel
		FROM 	GARANTES
		WHERE 	GaranteID = Var_GarHipID
		LIMIT 1;

	    SET Var_GarHipNom	:= IFNULL(Var_GarHipNom, Cadena_Vacia);
        SET Var_GarHipDir   := IFNULL(Var_GarHipDir, Cadena_Vacia);
        SET Var_GarHipTel   := IFNULL(Var_GarHipTel, Cadena_Vacia);
        SET Var_GarHipRelDe := '';
    END IF;

    IF (Par_NumCon = Con_SegF	|| Par_NumCon = Con_SegG) THEN
		SELECT	SolicitudCreditoID,	SucursalID,			ClienteID,			ProspectoID,	MontoSolici,
				DestinoCreID,		ProductoCreditoID,	PlazoID,			TasaFija,		FrecuenciaCap,
				MonedaID,			Estatus,			PromotorID
        INTO	Var_SolCredID,		Var_SucursalID,		Var_ClienteID,		Var_ProspecID,	Var_MontoSol,
				Var_DestCreID,		Var_ProdCredID,		Var_PlazoID,		Var_TasaFija,	Var_FrecCap,
                Var_MonedaID,		Var_Estatus,		Var_PromotorID
        FROM SOLICITUDCREDITO
			WHERE SolicitudCreditoID = Par_SolCredID;

		SET Var_SucursalDes	:= IFNULL((SELECT NombreSucurs FROM SUCURSALES WHERE SucursalID = Var_SucursalID), Cadena_Vacia);
        SET Var_DestCreDes	:= IFNULL((SELECT Descripcion FROM DESTINOSCREDITO WHERE DestinoCreID = Var_DestCreID), Cadena_Vacia);
        SET Var_ProdCredDes	:= IFNULL((SELECT Descripcion FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Var_ProdCredID), Cadena_Vacia);
        SET Var_PlazoDes	:= IFNULL((SELECT Descripcion FROM CREDITOSPLAZOS WHERE PlazoID = Var_PlazoID), Cadena_Vacia);
        SET Var_FrecCapDes	:= CASE Var_FrecCap
									WHEN FrecCapS THEN FrecCapSDes
                                    WHEN FrecCapC THEN FrecCapCDes
                                    WHEN FrecCapQ THEN FrecCapQDes
                                    WHEN FrecCapM THEN FrecCapMDes
                                    WHEN FrecCapP THEN FrecCapPDes
                                    WHEN FrecCapB THEN FrecCapBDes
                                    WHEN FrecCapT THEN FrecCapTDes
                                    WHEN FrecCapR THEN FrecCapRDes
                                    WHEN FrecCapE THEN FrecCapEDes
                                    WHEN FrecCapA THEN FrecCapADes
                                    WHEN FrecCapL THEN FrecCapLDes
                                    WHEN FrecCapU THEN FrecCapUDes
                                    WHEN FrecCapD THEN FrecCapDDes
                                    ELSE NOENCONTRADO
								END;

        SET Var_MonedaDes	:= IFNULL((SELECT Descripcion FROM MONEDAS WHERE MonedaId = Var_MonedaID), Cadena_Vacia);

        IF (Var_Estatus = FrecCapA) THEN
			SET Var_FecAutORech	:= IFNULL((SELECT FechaAutoriza FROM SOLICITUDCREDITO WHERE SolicitudCreditoID = Par_SolCredID), Fecha_Vacia);
            SET Var_ResolAut    := 'X';
            SET Var_ResolRech   := '';
        ELSE
			IF (Var_Estatus = FrecCapR) THEN
				SET Var_FecAutORech	:= IFNULL((SELECT FechaRechazo FROM SOLICITUDCREDITO WHERE SolicitudCreditoID = Par_SolCredID), Fecha_Vacia);
                SET Var_ResolAut    := '';
                SET Var_ResolRech   := 'X';
			END IF;
        END IF;

        SET Var_PromNombre	:= IFNULL((SELECT NombrePromotor FROM PROMOTORES WHERE PromotorID = Var_PromotorID), Cadena_Vacia);
		SET Var_SolCredID	:= IFNULL(Var_SolCredID, Entero_Cero);
		SET Var_Estatus		:= IFNULL(Var_Estatus, Cadena_Vacia);
		SET Var_FecAutORech	:= IFNULL(Var_FecAutORech, Fecha_Vacia);
        SET Var_ClienteID	:= IFNULL(Var_ClienteID, Entero_Cero);

        SET Var_ProspecID	:= IFNULL(Var_ProspecID, Entero_Cero);
        SET Var_MontoSol	:= IFNULL(Var_MontoSol, Decimal_Cero);
        SET Var_TasaFija	:= IFNULL(Var_TasaFija, Decimal_Cero);
	END IF;

    IF (Par_NumCon = Con_SegF) THEN
		IF (Var_ClienteID != Entero_Cero) THEN
			SET Var_GradoEsc	:= IFNULL((SELECT GradoEscolarID FROM SOCIODEMOGRAL WHERE ClienteID = Var_ClienteID), Entero_Cero);
			SET Var_GradoEscDes	:= IFNULL((SELECT Descripcion FROM CATGRADOESCOLAR WHERE GradoEscolarID = Var_GradoEsc), Cadena_Vacia);
			SET Var_TipoMat		:= IFNULL((SELECT TipoMaterialID FROM SOCIODEMOVIVIEN WHERE ClienteID = Var_ClienteID), Entero_Cero);
			SET Var_TipoMatDes	:= IFNULL((SELECT Descripcion FROM TIPOMATERIALVIV WHERE TipoMaterialID  = Var_GradoEsc), Cadena_Vacia);
			SET Var_ValorViv	:= IFNULL((SELECT ValorVivienda FROM SOCIODEMOVIVIEN WHERE ClienteID = Var_ClienteID), Decimal_Cero);

			SELECT	CONCAT(PrimerNombre, " ", SegundoNombre, " ", ApellidoPaterno, " ", ApellidoMaterno),
					OcupacionID,		EmpresaLabora,		FechaNacimiento,	Calle,			EstadoNacimiento,
					TelefonoTrabajo,	PaisNacimiento,		AntiguedadAnios,	Nacionalidad,	TelCelular
			INTO	Var_CYPriNombre,
					Var_CYOcupaID,		Var_CYEmpLab,		Var_CYFechaNac,		Var_CYCalle,	Var_CYEstadoNac,
					Var_CYTelTrab,		Var_CYPaisNac,		Var_CYAntigued,		Var_CYNacion,	Var_CYTelCel
			FROM SOCIODEMOCONYUG
				WHERE ClienteID = Var_ClienteID;

			SET Var_CYOcupaDes	:= IFNULL((SELECT Descripcion FROM OCUPACIONES WHERE OcupacionID = Var_CYOcupaID), Cadena_Vacia);
			SET Var_CYEdoNacDes	:= IFNULL((SELECT Nombre FROM ESTADOSREPUB WHERE EstadoID = Var_CYEstadoNac), Cadena_Vacia);
			SET Var_CYPaisDes	:= IFNULL((SELECT Nombre FROM PAISES WHERE PaisID = Var_CYPaisNac), Cadena_Vacia);
			SET Var_CYNacionDes	:=	CASE Var_CYNacion
										WHEN Var_CYNacionN THEN Var_CYNacionNAC
										WHEN Var_CYNacionE THEN Var_CYNacionEXT
										ELSE NOENCONTRADO
									END;
			SET Var_CYEdad 		:= (SELECT CAST(TIMESTAMPDIFF(YEAR, Var_CYFechaNac, Var_FechaActual)AS UNSIGNED));
			SET Var_NumHijos	:= IFNULL((SELECT COUNT(ClienteID) FROM SOCIODEMODEPEND WHERE ClienteID = Var_ClienteID AND TipoRelacionID = Entero_Tres), Entero_Cero);
			SET Var_NumDepen	:= IFNULL((SELECT NumDepenEconomi FROM SOCIODEMOGRAL WHERE ClienteID = Var_ClienteID), Entero_Cero);
			SET Var_GarantID	:= IFNULL((SELECT GarantiaID FROM ASIGNAGARANTIAS WHERE SolicitudCreditoID = Par_SolCredID LIMIT Entero_Uno), Entero_Cero);
			SET Var_GarantDes	:= IFNULL((SELECT Descripcion FROM TIPOGARANTIAS WHERE TipoGarantiasID = Var_GarantID), Cadena_Vacia);
		END IF;

		SET Var_GradoEscDes	:= IFNULL(Var_GradoEscDes, Cadena_Vacia);
		SET Var_TipoMatDes	:= IFNULL(Var_TipoMatDes, Cadena_Vacia);
		SET Var_ValorViv	:= IFNULL(Var_ValorViv, Decimal_Cero);
		SET Var_CYPriNombre	:= IFNULL(Var_CYPriNombre, Cadena_Vacia);
		SET Var_CYOcupaDes	:= IFNULL(Var_CYOcupaDes, Cadena_Vacia);
        SET Var_CYDirecAc   := Cadena_Vacia;
		SET Var_CYFechaNac	:= IFNULL(Var_CYFechaNac, Fecha_Vacia);
		SET Var_CYEdoNacDes	:= IFNULL(Var_CYEdoNacDes, Cadena_Vacia);
		SET Var_CYPaisDes	:= IFNULL(Var_CYPaisDes, Cadena_Vacia);
		SET Var_CYNacionDes	:= IFNULL(Var_CYNacionDes, Cadena_Vacia);
		SET Var_CYEdad		:= IFNULL(Var_CYEdad, Entero_Cero);

        SET Var_CYEmpLab	:= IFNULL(Var_CYEmpLab, Cadena_Vacia);
        SET Var_CYCalle		:= IFNULL(Var_CYCalle, Cadena_Vacia);
        SET Var_CYTelTrab	:= IFNULL(Var_CYTelTrab, Cadena_Vacia);
        SET Var_CYAntigued	:= IFNULL(Var_CYAntigued, Decimal_Cero);
        SET Var_CYTelCel	:= IFNULL(Var_CYTelCel, Cadena_Vacia);

        SET Var_NumHijos	:= IFNULL(Var_NumHijos, Entero_Cero);
        SET Var_NumDepen	:= IFNULL(Var_NumDepen, Entero_Cero);
        SET Var_GarantDes	:= IFNULL(Var_GarantDes, Cadena_Vacia);

	END IF;

	IF (Par_NumCon = Con_SegG) THEN
		SET Var_Pres	:= IFNULL((SELECT NombreCompleto FROM DIRECTIVOS WHERE ClienteID = Var_ClienteID AND CargoID = 13), Cadena_Vacia);
        SET Var_Secre	:= IFNULL((SELECT NombreCompleto FROM DIRECTIVOS WHERE ClienteID = Var_ClienteID AND CargoID = 14), Cadena_Vacia);
        SET Var_Teso	:= IFNULL((SELECT NombreCompleto FROM DIRECTIVOS WHERE ClienteID = Var_ClienteID AND CargoID = 15), Cadena_Vacia);

        SET Var_RLRelID	:= IFNULL((SELECT RelacionadoID FROM DIRECTIVOS WHERE CargoID = Entero_Dos AND ClienteID = Var_ClienteID LIMIT 1), Entero_Cero);

        IF (Var_RLRelID != Entero_Cero AND Var_RLRelID != Cadena_Vacia) THEN
			SELECT	CONCAT(Calle, ", N° ", NumeroCasa, ", ENTRE ", PrimeraEntreCalle, " Y ", SegundaEntreCalle,	", COL. ", Colonia, ", CP. ", CP)
			INTO	Var_RLDomCasa
			FROM DIRECCLIENTE
				WHERE ClienteID = Var_RLRelID
					AND Oficial = ContarCredS
				LIMIT 1;

			SELECT	NombreCompleto,	EstadoID,		PaisNacionalidad,	FechaNacimiento,	Nacion,
					OcupacionID,	Telefono
			INTO	Var_RLNomCom,	Var_RLEstadoID,	Var_RLPais,			Var_RLFecNac,		Var_RLNacion,
					Var_RLOcupID,	Var_RLTel
			FROM CLIENTES
				WHERE ClienteID = Var_RLRelID;

			SET Var_RLEstadoDes	:= IFNULL((SELECT Nombre FROM ESTADOSREPUB WHERE EstadoID = Var_RLEstadoID), Cadena_Vacia);
			SET Var_RLPaisDes	:= IFNULL((SELECT Nombre FROM PAISES WHERE PaisID = Var_RLPais), Cadena_Vacia);
			SET Var_RLOcupDes	:= IFNULL((SELECT Descripcion FROM OCUPACIONES WHERE OcupacionID = Var_RLOcupID), Cadena_Vacia);

			SET Var_RLNacDes	:=	CASE Var_RLNacion
										WHEN Var_CYNacionN THEN Var_CYNacionNAC
										WHEN Var_CYNacionE THEN Var_CYNacionEXT
										ELSE NOENCONTRADO
									END;
			SET Var_RLEdad	:= (SELECT CAST(TIMESTAMPDIFF(YEAR, Var_RLFecNac, Var_FechaActual)AS UNSIGNED));

			SET Var_RLConyNom	:= IFNULL((SELECT CONCAT(PrimerNombre, " ", SegundoNombre, " ", ApellidoPaterno, " ", ApellidoMaterno) FROM SOCIODEMOCONYUG WHERE ClienteID = Var_RLRelID), Cadena_Vacia);
			SET Var_RLNumDepen	:= IFNULL((SELECT NumDepenEconomi FROM SOCIODEMOGRAL WHERE ClienteID = Var_RLRelID), Entero_Cero);

			SET Var_RLCred		:= IFNULL((SELECT COUNT(CreditoID) FROM CREDITOS WHERE ClienteID = Var_RLRelID), Entero_Cero);
			SET Var_RLConCred	:= ContarCredN;
			IF (Var_RLCred > Entero_Cero) THEN
				SET Var_RLConCred	:= ContarCredS;
				SET Var_RLTipPer	:= IFNULL((SELECT TipoPersona FROM CLIENTES WHERE ClienteID = Var_RLRelID LIMIT 1), Cadena_Vacia);
				SET Var_RLTipPerDes	:=	CASE Var_RLTipPer
											WHEN Var_RLTipPerF THEN Var_RLPerFDes
											WHEN Var_RLTipPerM THEN Var_RLPerMDes
											WHEN Var_RLTipPerA THEN Var_RLPerADes
											ELSE NOENCONTRADO
										END;
            END IF;

			SET Var_RLCuantas	:= IFNULL((SELECT COUNT(RelacionadoID) FROM DIRECTIVOS WHERE CargoID = Entero_Dos AND RelacionadoID = Var_RLRelID), Entero_Cero);
			SET Var_RLCuaDes	:= ContarCredN;
			IF (Var_RLCuantas > Entero_Cero) THEN
				SET Var_RLCuaDes	:= ContarCredS;

				SET Var_RLCliOtro	:= IFNULL((SELECT ClienteID FROM DIRECTIVOS WHERE CargoID = Entero_Dos AND RelacionadoID = Var_RLRelID AND ClienteID != Var_ClienteID LIMIT Entero_Uno), Entero_Cero);
				SET Var_RLCliRS		:= IFNULL((SELECT RazonSocial FROM CLIENTES WHERE ClienteID = Var_RLCliOtro), Cadena_Vacia);
			END IF;

			SET Var_RLAccion	:= IFNULL((SELECT EsAccionista FROM DIRECTIVOS WHERE ClienteID = Var_RLRelID), Cadena_Vacia);
			IF (Var_RLAccion = ContarCredS) THEN
				SET Var_RLAccPor	:= IFNULL((SELECT PorcentajeAcciones FROM DIRECTIVOS WHERE ClienteID = Var_RLRelID), Decimal_Cero);
			END IF;
        END IF;

        SET Var_GarantID	:= IFNULL((SELECT GarantiaID FROM ASIGNAGARANTIAS WHERE SolicitudCreditoID = Par_SolCredID LIMIT Entero_Uno), Entero_Cero);
        SET Var_GarantDes	:= IFNULL((SELECT Descripcion FROM TIPOGARANTIAS WHERE TipoGarantiasID = Var_GarantID), Cadena_Vacia);
        SET Var_RLNomCom	:= IFNULL(Var_RLNomCom, Cadena_Vacia);
        SET Var_RLDomCasa	:= IFNULL(Var_RLDomCasa, Cadena_Vacia);
        SET Var_RLFecNac	:= IFNULL(Var_RLFecNac, Fecha_Vacia);

        SET Var_RLEstadoDes	:= IFNULL(Var_RLEstadoDes, Cadena_Vacia);
		SET Var_RLPaisDes	:= IFNULL(Var_RLPaisDes, Cadena_Vacia);
		SET Var_RLEdad		:= IFNULL(Var_RLEdad, Entero_Cero);
		SET Var_RLNacDes	:= IFNULL(Var_RLNacDes, Cadena_Vacia);
		SET Var_RLOcupDes	:= IFNULL(Var_RLOcupDes, Cadena_Vacia);

		SET Var_RLTel		:= IFNULL(Var_RLTel, Cadena_Vacia);
		SET Var_RLConyNom	:= IFNULL(Var_RLConyNom, Cadena_Vacia);
		SET Var_RLNumDepen	:= IFNULL(Var_RLNumDepen, Entero_Cero);
		SET Var_RLConCred	:= IFNULL(Var_RLConCred, Cadena_Vacia);
		SET Var_RLTipPerDes	:= IFNULL(Var_RLTipPerDes, Cadena_Vacia);

		SET Var_RLCuaDes	:= IFNULL(Var_RLCuaDes, Cadena_Vacia);
		SET Var_RLCliRS		:= IFNULL(Var_RLCliRS, Cadena_Vacia);
		SET Var_RLAccion	:= IFNULL(Var_RLAccion, Cadena_Vacia);
		SET Var_RLAccPor	:= IFNULL(Var_RLAccPor, Decimal_Cero);
	END IF;

	IF (Par_NumCon = Con_SegI) THEN
		SET Var_ClienteID	:= IFNULL((SELECT ClienteID FROM SOLICITUDCREDITO WHERE SolicitudCreditoID = Par_SolCredID), Entero_Cero);
		SET Var_NumPoliza 		:= IFNULL((SELECT NumPoliza FROM GARANTIAS WHERE GarantiaID = Var_GarantID), Entero_Cero);
        SET Var_RLRelID	:= IFNULL((SELECT RelacionadoID FROM DIRECTIVOS WHERE CargoID = Entero_Dos AND ClienteID = Var_ClienteID LIMIT 1), Entero_Cero);

        IF (Var_RLRelID != Entero_Cero AND Var_RLRelID != Cadena_Vacia) THEN
			SELECT	CONCAT(Calle, ", N° ", NumeroCasa, ", ENTRE ", PrimeraEntreCalle, " Y ", SegundaEntreCalle,	", COL. ", Colonia, ", CP. ", CP)
			INTO	Var_RLDomCasa
			FROM DIRECCLIENTE
				WHERE ClienteID = Var_RLRelID
					AND Oficial = ContarCredS
				LIMIT 1;

			SET Var_RLNomCom	:= (SELECT	NombreCompleto FROM CLIENTES WHERE ClienteID = Var_RLRelID);
		END IF;

		SET Var_RLDomCasa	:= IFNULL(Var_RLDomCasa, Cadena_Vacia);
		SET Var_RLNomCom	:= IFNULL(Var_RLNomCom, Cadena_Vacia);
    END IF;

	IF (Par_NumCon = Con_SegK	|| Par_NumCon = Con_SegL) THEN
		SET Var_FrecCap	:= IFNULL((SELECT FrecuenciaCap FROM SOLICITUDCREDITO WHERE SolicitudCreditoID = Par_SolCredID), Cadena_Vacia);
        SET Var_DiaMes	:= IFNULL((SELECT DiaMesCapital FROM SOLICITUDCREDITO WHERE SolicitudCreditoID = Par_SolCredID), Entero_Cero);
    END IF;

    -- CREACION
    DROP TEMPORARY TABLE IF EXISTS `TMPCONTRATOSSOLICITUD`;

	CREATE TEMPORARY TABLE `TMPCONTRATOSSOLICITUD` (
		NumTransaccion	BIGINT(20),		-- NumTransaccion para identificar n procesos a la vez
        LlaveParametro	VARCHAR(100),	-- Nombre de la columna
        ValorParametro	VARCHAR(500)	-- Valor de la columna
	);

	CALL TRANSACCIONESPRO(Transaccion);

-- INSERCIONES
	IF (Par_NumCon = Con_SegA) THEN
		INSERT INTO TMPCONTRATOSSOLICITUD(NumTransaccion, LlaveParametro, ValorParametro)
		VALUES	(Transaccion, Aseguradora,		Var_Aseguradora),
                (Transaccion, TipoOpe,	        Var_TipoOpe),
                (Transaccion, ClaSegVid,	    Var_ClaSegVid),
                (Transaccion, SeguroDan,	    Var_SeguroDan),
                (Transaccion, ClaSegDa,	        Var_ClaSegDa),
				(Transaccion, MontoAmpSV,		Var_MontoAmpSV);
    END IF;
    
	IF (Par_NumCon = Con_SegB) THEN
		INSERT INTO TMPCONTRATOSSOLICITUD(NumTransaccion, LlaveParametro, ValorParametro)
        VALUES 	(Transaccion, MonedaDes,	Var_MonedaDes),
				(Transaccion, MontoAmpSV,	Var_MontoAmpSV),
                (Transaccion, SeguroDan,	Var_SeguroDan);
	END IF;
    
    IF (Par_NumCon = Con_SegC) THEN
		INSERT INTO TMPCONTRATOSSOLICITUD(NumTransaccion, LlaveParametro, ValorParametro)
		VALUES	(Transaccion, ValorCom,		Var_ValorCom),
				(Transaccion, GarantID,		Var_GarantID),
                (Transaccion, MonAvaluo,	Var_MonAvaluo),
                (Transaccion, FecVerif,		Var_FecVerif),
                (Transaccion, TipPiso,		Var_TipoPiso),
                (Transaccion, FechaFin,		Var_FechaFin),
                (Transaccion, NomVal,		Var_NomVal),
                (Transaccion, NumeAvaluo,	Var_NumAvaluo),
                (Transaccion, FecValua,		Var_FecValua),
                (Transaccion, MonGarLiq,	Var_MontoGarLiq),
                (Transaccion, CtaAhoID,		Var_CuentaAhoID),
                (Transaccion, Aseguradora,	Var_Aseguradora),
                (Transaccion, MontoAmpSV,   Var_MontoAmpSV),
                (Transaccion, NumPoliza,	Var_NumPoliza),
                (Transaccion, VigInicioSV,  Var_VigInicioSV),
                (Transaccion, CoberturaSV,  Var_CoberturaSV),
                (Transaccion, VigFinSV,     Var_VigFinSV),
                (Transaccion, AvNomComp,	Var_AvNomComp);
    END IF;

    IF (Par_NumCon = Con_SegD) THEN
		INSERT INTO TMPCONTRATOSSOLICITUD(NumTransaccion, LlaveParametro, ValorParametro)
		VALUES	(Transaccion, MunIDDes,	Var_MunIDDes),
				(Transaccion, EdoIDDes,	CONCAT(Var_MunIDDes, ", " , Var_EdoIDDes));

		SET Var_CountAval	:= IFNULL((SELECT COUNT(AvalID) FROM AVALESPORSOLICI WHERE SolicitudCreditoID = Par_SolCredID), Entero_Cero);
        SET Var_Inicial		:= 0;
		loop_Daval : LOOP
			IF (Var_Inicial >= Var_CountAval) THEN
				LEAVE loop_Daval;
			END  IF;

            SET Var_AvalID		:= IFNULL((SELECT AvalID FROM AVALESPORSOLICI WHERE SolicitudCreditoID = Par_SolCredID LIMIT Var_Inicial, Entero_Uno), Entero_Cero);
			SET Var_Inicial 	:= Var_Inicial + 1;
            SET Var_AvNomComp	:= IFNULL((SELECT NombreCompleto FROM AVALES WHERE AvalID = Var_AvalID), Cadena_Vacia);

            INSERT INTO TMPCONTRATOSSOLICITUD(NumTransaccion, LlaveParametro, ValorParametro)
			VALUES	(Transaccion, CONCAT(AvNomComp, Var_Inicial),	Var_AvNomComp);
		END LOOP;
    END IF;

    IF (Par_NumCon = Con_SegF) THEN
		INSERT INTO TMPCONTRATOSSOLICITUD(NumTransaccion, LlaveParametro, ValorParametro)
        VALUES	(Transaccion, SoliCredID,	Var_SolCredID),
				(Transaccion, SucurDes,		Var_SucursalDes),
                (Transaccion, ClienID,		Var_ClienteID),
                (Transaccion, ProspecID,	Var_ProspecID),
                (Transaccion, MontoSoli,	Var_MontoSol),
                (Transaccion, DestCreDes,	Var_DestCreDes),
                (Transaccion, ProdCredDes,	Var_ProdCredDes),
                (Transaccion, PlazoDes,		Var_PlazoDes),
                (Transaccion, TasFij,		Var_TasaFija),
                (Transaccion, FrecCapDes,	Var_FrecCapDes),
                (Transaccion, MonedaDes,	Var_MonedaDes),
                (Transaccion, Esta,			Var_Estatus),
                (Transaccion, FecAutORech,	Var_FecAutORech),
                (Transaccion, ResAut,       Var_ResolAut),  
                (Transaccion, ResRech,       Var_ResolRech), 
                (Transaccion, PromNombre,	Var_PromNombre),
                (Transaccion, GradoEscDes,	Var_GradoEscDes),
                (Transaccion, TipoMatDes,	Var_TipoMatDes),
                (Transaccion, ValorVivi,	Var_ValorViv),
                (Transaccion, CYPriNombre,	Var_CYPriNombre),
                (Transaccion, CYOcupaDes,	Var_CYOcupaDes),
                (Transaccion, CYDirecAc,	Var_CYDirecAc),
                (Transaccion, CYEmpLab,		Var_CYEmpLab),
                (Transaccion, CYFechaNac,	Var_CYFechaNac),
                (Transaccion, CYCalle,		Var_CYCalle),
                (Transaccion, CYEdoNacDes,	Var_CYEdoNacDes),
                (Transaccion, CYTelTrab,	Var_CYTelTrab),
                (Transaccion, CYPaisDes,	Var_CYPaisDes),
                (Transaccion, CYAntiguedad,	Var_CYAntigued),
                (Transaccion, CYNacionDes,	Var_CYNacionDes),
                (Transaccion, CYTelCel,		Var_CYTelCel),
                (Transaccion, CYEdad,		Var_CYEdad),
                (Transaccion, NumHijos,		Var_NumHijos),
                (Transaccion, NumDepen,		Var_NumDepen),
                (Transaccion, GarantDes,	Var_GarantDes);
    END IF;

    IF (Par_NumCon = Con_SegG) THEN
    INSERT INTO TMPCONTRATOSSOLICITUD(NumTransaccion, LlaveParametro, ValorParametro)
        VALUES	(Transaccion, SoliCredID,	Var_SolCredID),
				(Transaccion, SucurDes,		Var_SucursalDes),
                (Transaccion, ClienID,		Var_ClienteID),
                (Transaccion, ProspecID,	Var_ProspecID),
                (Transaccion, MontoSoli,	Var_MontoSol),
                (Transaccion, DestCreDes,	Var_DestCreDes),
                (Transaccion, ProdCredDes,	Var_ProdCredDes),
                (Transaccion, PlazoDes,		Var_PlazoDes),
                (Transaccion, TasFij,		Var_TasaFija),
                (Transaccion, FrecCapDes,	Var_FrecCapDes),
                (Transaccion, MonedaDes,	Var_MonedaDes),
                (Transaccion, Esta,			Var_Estatus),
                (Transaccion, FecAutORech,	Var_FecAutORech),
                (Transaccion, ResAut,       Var_ResolAut),  
                (Transaccion, ResRech,      Var_ResolRech),
                (Transaccion, PromNombre,	Var_PromNombre),
                (Transaccion, Pres,			Var_Pres),
                (Transaccion, Secre,		Var_Secre),
                (Transaccion, Teso,			Var_Teso),
                (Transaccion, RLNomCom,		Var_RLNomCom),
                (Transaccion, RLDomCasa,	Var_RLDomCasa),
                (Transaccion, RLFecNac,		Var_RLFecNac),
                (Transaccion, RLEstadoDes,	Var_RLEstadoDes),
                (Transaccion, RLPaisDes,	Var_RLPaisDes),
                (Transaccion, RLEdad,		Var_RLEdad),
                (Transaccion, RLNacDes,		Var_RLNacDes),
                (Transaccion, RLOcupDes,	Var_RLOcupDes),
                (Transaccion, RLTel,		Var_RLTel),
                (Transaccion, RLConyNom,	Var_RLConyNom),
                (Transaccion, RLNumDepen,	Var_RLNumDepen),
                (Transaccion, RLConCred,	Var_RLConCred),
                (Transaccion, RLTipPerDes,	Var_RLTipPerDes),
                (Transaccion, RLCuaDes,		Var_RLCuaDes),
                (Transaccion, RLCliRS,		Var_RLCliRS),
                (Transaccion, RLAccion,		Var_RLAccion),
                (Transaccion, RLAccPor,		Var_RLAccPor),
                (Transaccion, GarantDes,	Var_GarantDes);

        
		SET Var_ClienteID	:= IFNULL((SELECT ClienteID FROM SOLICITUDCREDITO WHERE SolicitudCreditoID = Par_SolCredID), Entero_Cero);
		SET Var_CountDirec	:= IFNULL((SELECT COUNT(DirectivoID) FROM DIRECTIVOS WHERE ClienteID = Var_ClienteID), Entero_Cero);
        IF (Var_CountDirec > Entero_Cero) THEN
            SET Var_Inicial		:= 0;
            loop_dir : LOOP
                IF (Var_Inicial >= Var_CountDirec) THEN
                    LEAVE loop_dir;
                END IF;

                SELECT	NombreCompleto, PorcentajeAcciones
                INTO	Var_DirNomCom,	Var_DirPorcAcc
                FROM DIRECTIVOS
                    WHERE ClienteID = Var_ClienteID
                    LIMIT Var_Inicial, Entero_Uno;

                SET Var_Inicial 	:= Var_Inicial + 1;
                SET Var_DirNomCom	:= IFNULL(Var_DirNomCom, Cadena_Vacia);
                SET Var_DirPorcAcc	:= IFNULL(Var_DirPorcAcc, Decimal_Cero);

                INSERT INTO TMPCONTRATOSSOLICITUD(NumTransaccion, LlaveParametro, ValorParametro)
                VALUES	(Transaccion, CONCAT(SocAc, Var_Inicial),	Var_DirNomCom),
                        (Transaccion, CONCAT(SocAcP, Var_Inicial),	Var_DirPorcAcc);
            END LOOP;
        ELSE
            INSERT INTO TMPCONTRATOSSOLICITUD(NumTransaccion, LlaveParametro, ValorParametro)
                VALUES	(Transaccion, SocAc,	Cadena_Vacia),
                        (Transaccion, SocAcP,	Cadena_Vacia);
        END IF;

        SET Var_CuentaAhoID	:= IFNULL((SELECT CuentaAhoID FROM CUENTASAHO WHERE ClienteID = Var_ClienteID AND EsPrincipal = FrecCapS), Entero_Cero);
        SET Var_CountRL		:= IFNULL((SELECT COUNT(CuentaAhoID) FROM CUENTASPERSONA WHERE CuentaAhoID = Var_CuentaAhoID AND EsApoderado = FrecCapS), Entero_Cero);
        
        IF (Var_CountRL > Entero_Cero) THEN
            SET Var_Inicial		:= 0;
            loop_RL : LOOP
                IF (Var_Inicial >= Var_CountRL) THEN
                    LEAVE loop_RL;
                END IF;

                SELECT	CP.NombreCompleto,	CF.InstrucEspecial
                INTO	Var_PFNomCom,		Var_PFInsEspec
                FROM CUENTASPERSONA CP
                    LEFT OUTER JOIN CUENTASFIRMA CF ON CP.PersonaID = CF.PersonaID AND CP.CuentaAhoID = CF.CuentaAhoID
                WHERE CP.CuentaAhoID = Var_CuentaAhoID
                    AND CP.EsApoderado = FrecCapS
                    LIMIT Var_Inicial, Entero_Uno;

                SET Var_Inicial		:= Var_Inicial + 1;
                SET Var_PFNomCom	:= IFNULL(Var_PFNomCom, Cadena_Vacia);
                SET Var_PFInsEspec	:= IFNULL(Var_PFInsEspec, Cadena_Vacia);

                INSERT INTO TMPCONTRATOSSOLICITUD(NumTransaccion, LlaveParametro, ValorParametro)
                VALUES	(Transaccion, CONCAT(PodFacN, Var_Inicial),	Var_PFNomCom),
                        (Transaccion, CONCAT(PodFacI, Var_Inicial),	Var_PFInsEspec);
            END LOOP;
        ELSE
            INSERT INTO TMPCONTRATOSSOLICITUD(NumTransaccion, LlaveParametro, ValorParametro)
            VALUES	(Transaccion, PodFacN,	Cadena_Vacia),
                    (Transaccion, PodFacI,	Cadena_Vacia);
        END IF;
    END IF;

	IF (Par_NumCon = Con_SegF	|| Par_NumCon = Con_SegG) THEN
        SET Var_ClienteID	:= IFNULL((SELECT ClienteID FROM SOLICITUDCREDITO WHERE SolicitudCreditoID = Par_SolCredID), Entero_Cero);
		IF (Var_ClienteID != Entero_Cero) THEN

			INSERT INTO TMPCONTRATOSSOLICITUD(NumTransaccion, LlaveParametro, ValorParametro)
            SELECT Transaccion, CONCAT(DT, DATESTANDAR.Descripcion),	0.00
            FROM CATDATSOCIOE AS DATSOCIO
            INNER JOIN CATDATSOCIOESTANDAR AS DATESTANDAR
            ON DATSOCIO.CatSocioEID = DATESTANDAR.CatSocioEID;

            SET Var_DTIngreso   := 0;
            SET Var_DTGasto     := 0; 
            SET Var_CountDatSoc	:= IFNULL((SELECT COUNT(SocioEID) FROM CLIDATSOCIOE WHERE ClienteID = Var_ClienteID), Entero_Cero);
			SET Var_Inicial		:= 0;
			loop_dt : LOOP
				IF (Var_Inicial >= Var_CountDatSoc) THEN
					LEAVE loop_dt;
				END  IF;

				SELECT	CatSocioEID,	Monto
				INTO	Var_CatSoc,	Var_CatSocMon
				FROM 	CLIDATSOCIOE
				WHERE 	ClienteID = Var_ClienteID
				LIMIT 	Var_Inicial, Entero_Uno;

				SET Var_Inicial 	:= Var_Inicial + 1;
				SET Var_CatSocDes	:= IFNULL((SELECT Descripcion FROM CATDATSOCIOE WHERE CatSocioEID = Var_CatSoc), Cadena_Vacia);
                SET Var_CatSocTipo  := IFNULL((SELECT Tipo FROM CATDATSOCIOE WHERE CatSocioEID = Var_CatSoc), Cadena_Vacia);

                SET Var_CatSocDes	:= IFNULL(Var_CatSocDes, Var_Inicial);
				SET Var_CatSocMon	:= IFNULL(Var_CatSocMon, Decimal_Cero);

                IF (Var_CatSocTipo = EsIngreso) THEN
                    SET Var_DTIngreso   := Var_DTIngreso + Var_CatSocMon;
                ELSE
                    IF(Var_CatSocTipo = EsGasto) THEN
                        SET Var_DTGasto   := Var_DTGasto + Var_CatSocMon;
                    END IF;
                END IF;

				IF (Var_CatSocMon != 0.00) THEN
					UPDATE TMPCONTRATOSSOLICITUD
					SET ValorParametro = Var_CatSocMon
					WHERE LlaveParametro = CONCAT(DT, Var_CatSocDes);
                END IF;
			END LOOP;

            SET Var_Excedente := Var_DTIngreso - Var_DTGasto;

            INSERT INTO TMPCONTRATOSSOLICITUD(NumTransaccion, LlaveParametro, ValorParametro)
                VALUES	(Transaccion, DTIngreso,	Var_DTIngreso),
                        (Transaccion, DTGasto,	    Var_DTGasto),
                        (Transaccion, Excedente,     Var_Excedente);
		END IF;

        SET Var_CountAhoVis	:= IFNULL((SELECT COUNT(CuentaAhoID) FROM CUENTASAHO WHERE Estatus = EstCuenA AND ClienteID = Var_ClienteID), Entero_Cero);
        IF (Var_CountAhoVis > Entero_Cero) THEN
            SET Var_Inicial		:= 0;
            loop_av : LOOP
                IF (Var_Inicial >= Var_CountAhoVis) THEN
                    LEAVE loop_av;
                END  IF;

                SELECT	CuentaAhoID,	SaldoDispon
                INTO	Var_CuentaID,	Var_SaldoDispon
                FROM CUENTASAHO
                    WHERE ClienteID = Var_ClienteID
                    AND Estatus = EstCuenA
                    LIMIT Var_Inicial, Entero_Uno;

                SET Var_Inicial		:= Var_Inicial + 1;
                SET Var_CuentaID	:= IFNULL(Var_CuentaID, Entero_Cero);
                SET Var_SaldoDispon	:= IFNULL(Var_SaldoDispon, Decimal_Cero);

                INSERT INTO TMPCONTRATOSSOLICITUD(NumTransaccion, LlaveParametro, ValorParametro)
                VALUES	(Transaccion, CONCAT(CAVC, Var_Inicial),	Var_CuentaID),
                        (Transaccion, CONCAT(CAVM, Var_Inicial),	Var_SaldoDispon);
            END LOOP;
        ELSE
            INSERT INTO TMPCONTRATOSSOLICITUD(NumTransaccion, LlaveParametro, ValorParametro)
            VALUES	(Transaccion, CAVC,	Cadena_Vacia),
                    (Transaccion, CAVM, Cadena_Vacia);
        END IF;

        SET Var_CountInver	:= IFNULL((SELECT COUNT(InversionID) FROM INVERSIONES WHERE Estatus = EstInvN AND ClienteID = Var_ClienteID), Entero_Cero);
        IF (Var_CountInver > Entero_Cero) THEN
            SET Var_Inicial		:= 0;
            loop_inv : LOOP
                IF (Var_Inicial >= Var_CountInver) THEN
                    LEAVE loop_inv;
                END  IF;

                SELECT	InversionID, 		Monto, 		FechaInicio,	FechaVencimiento
                INTO 	Var_InversionID, 	Var_Mont, 	Var_FechaIni,	Var_FechaVenci
                FROM INVERSIONES
                    WHERE Estatus = EstInvN
                    AND ClienteID = Var_ClienteID
                    LIMIT Var_Inicial, Entero_Uno;

                SET Var_Inicial := Var_Inicial + 1;
                SET Var_InversionID	:= IFNULL(Var_InversionID, Entero_Cero);
                SET Var_Mont		:= IFNULL(Var_Mont, Decimal_Cero);
                SET Var_FechaIni	:= IFNULL(Var_FechaIni, Fecha_Vacia);
                SET Var_FechaVenci	:= IFNULL(Var_FechaVenci, Fecha_Vacia);

                INSERT INTO TMPCONTRATOSSOLICITUD(NumTransaccion, LlaveParametro, ValorParametro)
                VALUES	(Transaccion, CONCAT(InvI, Var_Inicial),	Var_InversionID),
                        (Transaccion, CONCAT(InvM, Var_Inicial),	Var_Mont),
                        (Transaccion, CONCAT(InvF, Var_Inicial),	Var_FechaIni),
                        (Transaccion, CONCAT(InvV, Var_Inicial),	Var_FechaVenci);
            END LOOP;
        ELSE 
            INSERT INTO TMPCONTRATOSSOLICITUD(NumTransaccion, LlaveParametro, ValorParametro)
            VALUES	(Transaccion, InvI,	Cadena_Vacia),
                    (Transaccion, InvM,	Cadena_Vacia),
                    (Transaccion, InvF,	Cadena_Vacia),
                    (Transaccion, InvV,	Cadena_Vacia);
        END IF;

        SET Var_CountAval	:= IFNULL((SELECT COUNT(AvalID) FROM AVALESPORSOLICI WHERE SolicitudCreditoID = Par_SolCredID), Entero_Cero);
        SET Var_Inicial		:= 0;
		loop_Faval : LOOP
			IF (Var_Inicial >= Var_CountAval) THEN
				LEAVE loop_Faval;
			END  IF;

            SET Var_AvalID		:= IFNULL((SELECT AvalID FROM AVALESPORSOLICI WHERE SolicitudCreditoID = Par_SolCredID LIMIT Var_Inicial, Entero_Uno), Entero_Cero);
			SET Var_Inicial 	:= Var_Inicial + 1;

            SELECT	NombreCompleto,	DireccionCompleta,	Telefono
            INTO	Var_AVNomComp,	Var_AVDirCom, 		Var_AVTelefono
            FROM AVALES
				WHERE AvalID = Var_AvalID;

            SET Var_AVTipRel	:= IFNULL((SELECT TipoRelacionID FROM AVALESPORSOLICI WHERE AvalID = Var_AvalID AND SolicitudCreditoID = Par_SolCredID LIMIT Entero_Uno), Entero_Cero);
            SET Var_AVTipRelDes	:= IFNULL((SELECT Descripcion FROM TIPORELACIONES WHERE TipoRelacionID = Var_AVTipRel), Cadena_Vacia);

            SET Var_AvNomComp	:= IFNULL(Var_AvNomComp, Cadena_Vacia);
            SET Var_AVDirCom	:= IFNULL(Var_AVDirCom, Cadena_Vacia);
            SET Var_AVTelefono	:= IFNULL(Var_AVTelefono, Cadena_Vacia);

            INSERT INTO TMPCONTRATOSSOLICITUD(NumTransaccion, LlaveParametro, ValorParametro)
			VALUES	(Transaccion, CONCAT(AvNomComp, Var_Inicial),	Var_AvNomComp),
					(Transaccion, CONCAT(AVDirCom, Var_Inicial),	Var_AVDirCom),
                    (Transaccion, CONCAT(AVTelefono, Var_Inicial),	Var_AVTelefono),
                    (Transaccion, CONCAT(AVTipRelDes, Var_Inicial),	Var_AVTipRelDes);
		END LOOP;

        INSERT INTO TMPCONTRATOSSOLICITUD(NumTransaccion, LlaveParametro, ValorParametro)
		VALUES	(Transaccion, GarHipNom,        Var_GarHipNom),
			    (Transaccion, GarHipDir,        Var_GarHipDir),
                (Transaccion, GarHipTel,        Var_GarHipTel),
                (Transaccion, GarHipRelDe,	    Var_GarHipRelDe);
    END IF;

    IF (Par_NumCon = Con_SegI) THEN
		INSERT INTO TMPCONTRATOSSOLICITUD(NumTransaccion, LlaveParametro, ValorParametro)
        VALUES	(Transaccion, RLNomCom,		Var_RLNomCom),
				(Transaccion, RLDomCasa,	Var_RLDomCasa),
                (Transaccion, NumPoliza,		Var_NumPoliza);
    END IF;

    IF (Par_NumCon = Con_SegK	|| Par_NumCon = Con_SegL) THEN
		INSERT INTO TMPCONTRATOSSOLICITUD(NumTransaccion, LlaveParametro, ValorParametro)
        VALUES	(Transaccion, DiaMes,	Var_DiaMes),
				(Transaccion, SucDirec,	Var_SucDirec),
				(Transaccion, MunIDDes,	Var_MunIDDes),
				(Transaccion, EdoIDDes,	Var_EdoIDDes);

        SET Var_CountAval	:= IFNULL((SELECT COUNT(AvalID) FROM AVALESPORSOLICI WHERE SolicitudCreditoID = Par_SolCredID), Entero_Cero);
        SET Var_Inicial		:= 0;
		loop_Kaval : LOOP
			IF (Var_Inicial >= Var_CountAval) THEN
				LEAVE loop_Kaval;
			END  IF;

            SET Var_AvalID		:= IFNULL((SELECT AvalID FROM AVALESPORSOLICI WHERE SolicitudCreditoID = Par_SolCredID LIMIT Var_Inicial, Entero_Uno), Entero_Cero);
			SET Var_Inicial 	:= Var_Inicial + 1;

            SELECT	NombreCompleto,	CONCAT(Calle, " ", NumExterior),	Colonia,
					LocalidadID,	MunicipioID,	EstadoID,		LugarNacimiento,	CP
            INTO	Var_AVNomComp,	Var_PACalle,						Var_PAColonia,
					Var_PALocID,	Var_PAMunID,	Var_PAEdoID,	Var_PALugNac,		Var_PACP
            FROM AVALES
				WHERE AvalID = Var_AvalID;

            SET Var_PALocIDDes	:= IFNULL((SELECT NombreLocalidad FROM LOCALIDADREPUB WHERE LocalidadID = Var_PALocID AND EstadoID = Var_PAEdoID AND MunicipioID = Var_PAMunID), Cadena_Vacia);
            SET Var_PAMunIDDes	:= IFNULL((SELECT Nombre FROM MUNICIPIOSREPUB WHERE MunicipioID = Var_PAMunID AND EstadoID = Var_PAEdoID), Cadena_Vacia);
            SET Var_PAEdoIDDes	:= IFNULL((SELECT Nombre FROM ESTADOSREPUB WHERE EstadoID = Var_PAEdoID), Cadena_Vacia);
            SET Var_PAPaisNom	:= IFNULL((SELECT Nombre FROM PAISES WHERE PaisID = Var_PALugNac), Cadena_Vacia);
            SET Var_AVNomComp	:= IFNULL(Var_AVNomComp, Cadena_Vacia);

			SET Var_PAColonia	:= IFNULL(Var_PAColonia, Cadena_Vacia);
			SET Var_PALocIDDes	:= IFNULL(Var_PALocIDDes, Cadena_Vacia);
			SET Var_PAMunIDDes	:= IFNULL(Var_PAMunIDDes, Cadena_Vacia);
			SET Var_PAEdoIDDes	:= IFNULL(Var_PAEdoIDDes, Cadena_Vacia);
			SET Var_PAPaisNom	:= IFNULL(Var_PAPaisNom, Cadena_Vacia);
			SET Var_PACP		:= IFNULL(Var_PACP, Cadena_Vacia);

            INSERT INTO TMPCONTRATOSSOLICITUD(NumTransaccion, LlaveParametro, ValorParametro)
			VALUES	(Transaccion, CONCAT(AVNomComp, Var_Inicial),	Var_AVNomComp),
					(Transaccion, CONCAT(AVCalle, Var_Inicial),		Var_PACalle),
					(Transaccion, CONCAT(AVColonia, Var_Inicial),	Var_PAColonia),
                    (Transaccion, CONCAT(AVLoc, Var_Inicial),		Var_PALocIDDes),
                    (Transaccion, CONCAT(AVMun, Var_Inicial),		Var_PAMunIDDes),
                    (Transaccion, CONCAT(AVEdo, Var_Inicial),		Var_PAEdoIDDes),
					(Transaccion, CONCAT(AVPais, Var_Inicial),		Var_PAPaisNom),
                    (Transaccion, CONCAT(AVCP, Var_Inicial),		Var_PACP);
		END LOOP;
    END IF;

    SELECT NumTransaccion, LlaveParametro, ValorParametro FROM TMPCONTRATOSSOLICITUD;

    DROP TEMPORARY TABLE IF EXISTS `TMPCONTRATOSSOLICITUD`;
END TerminaStore$$