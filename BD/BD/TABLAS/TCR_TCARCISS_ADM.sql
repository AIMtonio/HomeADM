-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TCR_TCARCISS_ADM
DELIMITER ;
DROP TABLE IF EXISTS `TCR_TCARCISS_ADM`;DELIMITER $$

CREATE TABLE `TCR_TCARCISS_ADM` (
  `Iss_FolioAr` decimal(6,0) DEFAULT NULL COMMENT 'Folio del archivo ISS',
  `Iss_Enviado` char(1) DEFAULT NULL COMMENT 'Enviado Folio del archivo ISS',
  `Iss_FecGen` datetime DEFAULT NULL COMMENT 'Fecha de Generacion del archivo ISS',
  `Iss_Seccion` smallint(6) DEFAULT NULL COMMENT 'Seccion del archivo ISS',
  `Iss_S1Cam1` varchar(7) DEFAULT NULL COMMENT 'Valor Fijo HEADER',
  `Iss_S1Cam2` varchar(3) DEFAULT NULL COMMENT 'Valor Fijo ISS',
  `Iss_S1Cam3` varchar(5) DEFAULT NULL COMMENT 'Valor proporcionado por PROSA cuando se inicia la configuracion en el autorizador',
  `Iss_S1Cam4` varchar(4) DEFAULT NULL COMMENT 'Valor Fijo CARD',
  `Iss_S1Cam5` varchar(2) DEFAULT NULL COMMENT 'Indicador  Diario',
  `Iss_S1Cam6` varchar(6) DEFAULT NULL COMMENT 'Extension .IN ',
  `Iss_S1Cam7` varchar(4) DEFAULT NULL COMMENT 'Consecutivo de archivos enviados,Esta secuencia es incremental y NO se puede repetir .',
  `Iss_S1Cam8` varchar(12) DEFAULT NULL COMMENT 'Fecha de creacion del archivo',
  `Iss_S1Cam9` varchar(8) DEFAULT NULL COMMENT 'Valor Fijo SISTEMA',
  `Iss_S1Cam10` varchar(16) DEFAULT NULL COMMENT 'Password proporcionado por PROSA',
  `Iss_S1Cam11` varchar(9) DEFAULT NULL COMMENT 'Suma de todos los registros',
  `Iss_S1Cam12` varchar(6) DEFAULT NULL COMMENT 'valor fijo = 0',
  `Iss_S2Cam1` varchar(16) DEFAULT NULL COMMENT 'Usuario con permiso para realizar la tarea ',
  `Iss_S2Cam2` varchar(16) DEFAULT NULL COMMENT 'Contraseña cifrada del usuario en el sistema CMS.',
  `Iss_S2Cam3` varchar(7) DEFAULT NULL COMMENT 'Consecutivo para todos los registros que no son header y trailer',
  `Iss_S2Cam4` varchar(9) DEFAULT NULL COMMENT 'Agrupador para indicar los registros que pertencen a un movimiento: Alta o Modificacion',
  `Iss_S2Cam5` varchar(4) DEFAULT NULL COMMENT 'Modificaciones que corresponden a los registros 0011 y 0012',
  `Iss_S2Cam6` varchar(4) DEFAULT NULL COMMENT 'Emisor Se revisa contra la tabla de emisores',
  `Iss_S2Cam7` varchar(5) DEFAULT NULL COMMENT 'Numero de sucursal que tendrá asociada la solicitud de alta o que tiene asignado ya un registro',
  `Iss_S2Cam8` varchar(2) DEFAULT NULL COMMENT 'ID de banco de clientes',
  `Iss_S2Cam9` varchar(30) DEFAULT NULL COMMENT 'Identifica la cuenta',
  `Iss_S2Cam10` varchar(2) DEFAULT NULL COMMENT 'Tipo de documento del Autorizador',
  `Iss_S2Cam11` varchar(15) DEFAULT NULL COMMENT 'Identificador del numero de documento',
  `Iss_S2Cam12` varchar(19) DEFAULT NULL COMMENT 'Numero es generado por el banco',
  `Iss_S2Cam13` varchar(19) DEFAULT NULL COMMENT 'Tarjeta primaria  que se utiliza',
  `Iss_S2Cam14` varchar(7) DEFAULT NULL COMMENT 'Grupo de afinidad de la cuenta Solo se utiliza para el titular de la tarjeta principal',
  `Iss_S2Cam15` varchar(8) DEFAULT NULL COMMENT 'Fecha de generacion del archivo, se coloca la misma para los registros 15 y 16 ',
  `Iss_S2Cam16` varchar(8) DEFAULT NULL COMMENT 'Fecha de procesamiento',
  `Iss_S2Cam17` varchar(15) DEFAULT NULL COMMENT 'Referencia de la propuesta Es el codigo relacionado con la propuesta asignada.',
  `Iss_S2Cam18` varchar(2) DEFAULT NULL COMMENT 'Tipo de tarjeta.',
  `Iss_S2Cam19` varchar(4) DEFAULT NULL COMMENT 'Codigo de costo.Se verifica que este codigo sea valido para el Emisor y el producto.',
  `Iss_S2Cam20` varchar(6) DEFAULT NULL COMMENT 'Fecha de vencimiento',
  `Iss_S2Cam21` varchar(2) DEFAULT NULL COMMENT 'Meses de validez Es la cantidad de meses durante los cuales la tarjeta es valida para reimpresion y generacion',
  `Iss_S2Cam22` varchar(1) DEFAULT NULL COMMENT 'Indicador de si el cliente es VIP o no',
  `Iss_S2Cam23` varchar(27) DEFAULT NULL COMMENT 'Nombre que aparece en la tarjeta',
  `Iss_S2Cam24` varchar(25) DEFAULT NULL COMMENT 'Segunda linea de embosado de la tarjeta',
  `Iss_S2Cam25` varchar(16) DEFAULT NULL COMMENT 'Numero de identificacion personal',
  `Iss_S2Cam26` varchar(79) DEFAULT NULL COMMENT 'Informacion adicional para ser grabado en la primer banda magnetica de la tarjeta',
  `Iss_S2Cam27` varchar(40) DEFAULT NULL COMMENT 'Informacion adicional para ser grabado en la segunda banda magnetica de la tarjeta',
  `Iss_S2Cam28` varchar(16) DEFAULT NULL COMMENT 'Contraseña del telefono',
  `Iss_S2Cam29` varchar(8) DEFAULT NULL COMMENT 'Fecha de validez de la contraseña del telefono.',
  `Iss_S2Cam30` varchar(16) DEFAULT NULL COMMENT 'Correo Electronico',
  `Iss_S2Cam31` varchar(1) DEFAULT NULL COMMENT 'Direccion donde deben de enviarse las tarjetas',
  `Iss_S2Cam32` varchar(2) DEFAULT NULL COMMENT 'Valor del compañía de entrega de plasticos',
  `Iss_S2Cam33` varchar(2) DEFAULT NULL COMMENT 'Indica el valor del embozador asociado al cliente.',
  `Iss_S2Cam34` varchar(2) DEFAULT NULL COMMENT 'Fecha de cierre de la tarjeta',
  `Iss_S2Cam35` varchar(8) DEFAULT NULL COMMENT 'Fecha de nacimiento del cliente',
  `Iss_S2Cam36` varchar(25) DEFAULT NULL COMMENT 'Lugar de nacimiento DEL cliente',
  `Iss_S2Cam37` varchar(25) DEFAULT NULL COMMENT 'Nacionalidad del cliente',
  `Iss_S2Cam38` varchar(1) DEFAULT NULL COMMENT 'Genero de la persona',
  `Iss_S2Cam39` varchar(2) DEFAULT NULL COMMENT 'Estado civil',
  `Iss_S2Cam40` varchar(60) DEFAULT NULL COMMENT 'Nombre completo del cliente.',
  `Iss_S2Cam41` varchar(4) DEFAULT NULL COMMENT 'Ocupacion del cliente.',
  `Iss_S2Cam42` varchar(4) DEFAULT NULL COMMENT 'Linea de negocio',
  `Iss_S2Cam43` varchar(2) DEFAULT NULL COMMENT 'Cantidad de empleados',
  `Iss_S2Cam44` varchar(15) DEFAULT NULL COMMENT 'RFC de los clientes',
  `Iss_S2Cam45` varchar(10) DEFAULT NULL COMMENT 'Organizacion de los clientes',
  `Iss_S2Cam46` varchar(4) DEFAULT NULL COMMENT 'Estado de la republica',
  `Iss_S2Cam47` varchar(1) DEFAULT NULL COMMENT 'Sobre el limite de tarjeta',
  `Iss_S2Cam48` varchar(2) DEFAULT NULL COMMENT 'Grupo de la tarjeta y la Linea de la cuenta.',
  `Iss_S2Cam49` varchar(2) DEFAULT NULL COMMENT 'Moneda de la cuenta',
  `Iss_S2Cam50` varchar(30) DEFAULT NULL COMMENT 'Cuenta bancaria',
  `Iss_S2Cam51` varchar(16) DEFAULT NULL COMMENT 'Contraseña de autenticacion de operaciones del cliente.',
  `Iss_S2Cam52` varchar(2) DEFAULT NULL COMMENT 'Lenguaje de opercion',
  `Iss_S2Cam53` varchar(127) DEFAULT NULL COMMENT 'Nivel de acceso de la tarjeta a la cuenta',
  `Iss_S2Cam54` varchar(4) DEFAULT NULL COMMENT 'Codigo de canales de venta',
  `Iss_S2Cam55` varchar(4) DEFAULT NULL COMMENT 'Campaña de ventas',
  `Iss_S2Cam56` varchar(10) DEFAULT NULL COMMENT 'Valor del promotor de la venta',
  `Iss_S2Cam57` varchar(1) DEFAULT NULL COMMENT 'Valor del Cheque de consignacion.',
  `Iss_S2Cam58` varchar(1) DEFAULT NULL COMMENT 'Valor de remesa',
  `Iss_S2Cam59` varchar(40) DEFAULT NULL COMMENT 'Nombre del padre del cliente',
  `Iss_S2Cam60` varchar(40) DEFAULT NULL COMMENT 'Nombre de la madre del cliente',
  `Iss_S2Cam61` varchar(2) DEFAULT NULL COMMENT 'Color de la Tarjeta',
  `Iss_S2Cam62` varchar(60) DEFAULT NULL COMMENT 'Nombre del titular de la tarjeta',
  `Iss_S2Cam63` varchar(60) DEFAULT NULL COMMENT 'Apellido del titular de la tarjeta',
  `Iss_S2Cam64` varchar(5) DEFAULT NULL COMMENT 'Aplicar servicios predeterminados',
  `Iss_S2Cam65` varchar(1) DEFAULT NULL COMMENT 'Indicador de si el plastico lleva foto o no.',
  `Iss_S2Cam66` varchar(1) DEFAULT NULL COMMENT 'Nivel de relacion',
  `Iss_S2Cam67` varchar(1) DEFAULT NULL COMMENT 'Numero de Pamcard',
  `Iss_S2Cam68` varchar(7) DEFAULT NULL COMMENT 'Identificador de tipo de carrier que llevará la tarjeta',
  `Iss_S2Cam69` varchar(2) DEFAULT NULL COMMENT 'Tipo de tarjetahabiente',
  `Iss_S2Cam70` varchar(1) DEFAULT NULL COMMENT 'Tipo de controlador',
  `Iss_S2Cam71` varchar(1) DEFAULT NULL COMMENT 'Via de tarjeta',
  `Iss_S2Cam72` varchar(2) DEFAULT NULL COMMENT 'Prestamo para una cuenta',
  `Iss_S2Cam73` varchar(1) DEFAULT NULL COMMENT 'Prestamo permitido para una cuenta',
  `Iss_S2Cam74` varchar(8) DEFAULT NULL COMMENT 'Codigo del Comerciante',
  `Iss_S2Cam75` varchar(5) DEFAULT NULL COMMENT 'Bono cuenta',
  `Iss_S2Cam76` varchar(1) DEFAULT NULL COMMENT 'Indicador de necesidades especiales del titular de la tarjeta',
  `Iss_S2Cam77` varchar(2) DEFAULT NULL COMMENT 'Codigo de Necesidades Especiales del Tarjetahabiente',
  `Iss_S2Cam78` text COMMENT 'Relleno',
  `Iss_S3Cam1` varchar(16) DEFAULT NULL COMMENT 'Usuario con permiso para realizar las siguientes tareas: generar cuentas, tarjetas.',
  `Iss_S3Cam2` varchar(16) DEFAULT NULL COMMENT 'Contraseña cifrada del usuario en el sistema CMS.',
  `Iss_S3Cam3` varchar(7) DEFAULT NULL COMMENT 'Consecutivo para todos los registros que no son header y trailer',
  `Iss_S3Cam4` varchar(9) DEFAULT NULL COMMENT 'Es un agrupador para indicar los registros que pertencen a un movimiento: Alta o Modificacion',
  `Iss_S3Cam5` varchar(4) DEFAULT NULL COMMENT 'Codigo de mensaje',
  `Iss_S3Cam6` varchar(4) DEFAULT NULL COMMENT 'Emisor Se revisa contra la tabla de emisores',
  `Iss_S3Cam7` varchar(5) DEFAULT NULL COMMENT 'Numero de sucursal que tendrá asociada la solicitud de alta o que tiene asignado ya un registro',
  `Iss_S3Cam8` varchar(2) DEFAULT NULL COMMENT 'Producto valido para el Emisor.',
  `Iss_S3Cam9` varchar(30) DEFAULT NULL COMMENT 'ID del banco de clientes,Identifica la cuenta',
  `Iss_S3Cam10` varchar(2) DEFAULT NULL COMMENT 'Tipo de documento del titular de la tarjeta',
  `Iss_S3Cam11` varchar(15) DEFAULT NULL COMMENT 'Numero del Documento. El digito de comprobacion está validado.',
  `Iss_S3Cam12` varchar(19) DEFAULT NULL COMMENT 'Numero de Pamcard',
  `Iss_S3Cam13` varchar(4) DEFAULT NULL COMMENT 'Moneda de operacion del producto',
  `Iss_S3Cam14` varchar(18) DEFAULT NULL COMMENT 'Valor del limite de credito de la cuenta.',
  `Iss_S3Cam15` varchar(18) DEFAULT NULL COMMENT 'Sueldo del titular de la tarjeta de credito para el calculo del limite de credito.',
  `Iss_S3Cam16` varchar(1) DEFAULT NULL COMMENT 'Indica si el limite de la cuenta será generado por el CMS basado en las reglas del emisor',
  `Iss_S3Cam17` varchar(18) DEFAULT NULL COMMENT 'Cantidad en consignacion',
  `Iss_S3Cam18` varchar(1) DEFAULT NULL COMMENT 'Tipo de incremento',
  `Iss_S4Cam1` varchar(16) DEFAULT NULL COMMENT 'Usuario de CMS',
  `Iss_S4Cam2` varchar(16) DEFAULT NULL COMMENT 'Contraseña cifrada del usuario en el sistema CMS',
  `Iss_S4Cam3` varchar(7) DEFAULT NULL COMMENT 'Consecutivo para todos los registros que no son header y trailer',
  `Iss_S4Cam4` varchar(9) DEFAULT NULL COMMENT 'Agrupador para indicar los registros que pertencen a un movimiento: Alta o Modificacion',
  `Iss_S4Cam5` varchar(4) DEFAULT NULL COMMENT 'codigo de mensaje',
  `Iss_S4Cam6` varchar(4) DEFAULT NULL COMMENT 'Emisor Se revisa contra la tabla de emisores.',
  `Iss_S4Cam7` varchar(5) DEFAULT NULL COMMENT 'Numero de sucursal que tendrá asociada la solicitud de alta o que tiene asignado ya un registro',
  `Iss_S4Cam8` varchar(2) DEFAULT NULL COMMENT 'Producto valido para el Emisor.',
  `Iss_S4Cam9` varchar(30) DEFAULT NULL COMMENT 'ID del banco de clientes',
  `Iss_S4Cam10` varchar(2) DEFAULT NULL COMMENT 'Tipo de documento del titular de la tarjeta',
  `Iss_S4Cam11` varchar(15) DEFAULT NULL COMMENT 'Numero de documento del titular de la tarjeta',
  `Iss_S4Cam12` varchar(19) DEFAULT NULL COMMENT 'Numero de Pamcard.',
  `Iss_S4Cam13` varchar(2) DEFAULT NULL COMMENT 'Tipo de direccion',
  `Iss_S4Cam14` varchar(60) DEFAULT NULL COMMENT 'Nombre de la Calle',
  `Iss_S4Cam15` varchar(5) DEFAULT NULL COMMENT 'Numero Exterior',
  `Iss_S4Cam16` varchar(50) DEFAULT NULL COMMENT 'Nombre de la Colonia ',
  `Iss_S4Cam17` varchar(30) DEFAULT NULL COMMENT 'Direccion Complemento ',
  `Iss_S4Cam18` varchar(50) DEFAULT NULL COMMENT 'Municipio ',
  `Iss_S4Cam19` varchar(4) DEFAULT NULL COMMENT 'Estado de la republica ',
  `Iss_S4Cam20` varchar(3) DEFAULT NULL COMMENT 'Codigo de pais',
  `Iss_S4Cam21` varchar(10) DEFAULT NULL COMMENT 'Codigo postal',
  `Iss_S4Cam22` varchar(20) DEFAULT NULL COMMENT 'Telefono con el formato de visualizacion.',
  `Iss_S4Cam23` varchar(20) DEFAULT NULL COMMENT 'Fax con el formato de visualizacion.',
  `Iss_S4Cam24` varchar(20) DEFAULT NULL COMMENT 'Celular con el formato de visualizacion.',
  `Iss_S4Cam25` varchar(128) DEFAULT NULL COMMENT 'Correo Electronico',
  `Iss_S4Cam26` varchar(8) DEFAULT NULL COMMENT 'Fecha de Baja',
  `Iss_S4Cam27` varchar(8) DEFAULT NULL COMMENT 'Fecha de nacimiento',
  `Iss_S4Cam28` varchar(10) DEFAULT NULL COMMENT 'Numero Interno',
  `Iss_S4Cam29` varchar(8) DEFAULT NULL COMMENT 'Periodo en que el titular vive en la Direccion especificada.',
  `Iss_S4Cam30` varchar(2) DEFAULT NULL COMMENT 'Tipo de direccion de entrega.',
  `Iss_S4Cam31` varchar(48) DEFAULT NULL COMMENT 'Relleno',
  `Iss_S5Cam1` varchar(16) DEFAULT NULL COMMENT 'Usuario de CMS',
  `Iss_S5Cam2` varchar(16) DEFAULT NULL COMMENT 'Contraseña cifrada del usuario en el sistema CMS',
  `Iss_S5Cam3` varchar(7) DEFAULT NULL COMMENT 'Consecutivo para todos los registros que no son header y trailer',
  `Iss_S5Cam4` varchar(9) DEFAULT NULL COMMENT 'Agrupador para indicar los registros que pertencen a un movimiento: Alta o Modificacion',
  `Iss_S5Cam5` varchar(4) DEFAULT NULL COMMENT 'codigo de mensaje',
  `Iss_S5Cam6` varchar(4) DEFAULT NULL COMMENT 'Emisor Se revisa contra la tabla de emisores.',
  `Iss_S5Cam7` varchar(5) DEFAULT NULL COMMENT 'Numero de sucursal que tendrá asociada la solicitud de alta o que tiene asignado ya un registro',
  `Iss_S5Cam8` varchar(2) DEFAULT NULL COMMENT 'Producto valido para el Emisor.',
  `Iss_S5Cam9` varchar(30) DEFAULT NULL COMMENT 'ID del banco de clientes',
  `Iss_S5Cam10` varchar(2) DEFAULT NULL COMMENT 'Tipo de documento del titular de la tarjeta',
  `Iss_S5Cam11` varchar(15) DEFAULT NULL COMMENT 'Numero de documento del titular de la tarjeta',
  `Iss_S5Cam12` varchar(19) DEFAULT NULL COMMENT 'Numero de Pamcard.',
  `Iss_S5Cam13` varchar(8) DEFAULT NULL COMMENT 'Fecha',
  `Iss_S5Cam14` varchar(64) DEFAULT NULL COMMENT 'Nombre de la compañía',
  `Iss_S5Cam15` varchar(64) DEFAULT NULL COMMENT 'Puesto de la persona',
  `Iss_S5Cam16` varchar(18) DEFAULT NULL COMMENT 'Salario del empleado',
  `Iss_S5Cam17` varchar(8) DEFAULT NULL COMMENT 'Fecha de Admision',
  `Iss_S5Cam18` varchar(4) DEFAULT NULL COMMENT 'Linea de negocio',
  `Iss_S5Cam19` varchar(15) DEFAULT NULL COMMENT 'Codigo CGC de compañía',
  `Iss_S5Cam20` varchar(30) DEFAULT NULL COMMENT 'Sucursal de la compañía',
  `Iss_S5Cam21` varchar(30) DEFAULT NULL COMMENT 'Departamento de la compañía',
  `Iss_S5Cam22` varchar(30) DEFAULT NULL COMMENT 'Area de la compañía',
  `Iss_S5Cam23` varchar(12) DEFAULT NULL COMMENT 'Numero de empleado',
  `Iss_S5Cam24` varchar(128) DEFAULT NULL COMMENT 'Correo Electronico',
  `Iss_S5Cam25` varchar(1) DEFAULT NULL COMMENT 'Tipo de contrato',
  `Iss_S5Cam26` varchar(1) DEFAULT NULL COMMENT 'Tipo de Ingreso',
  `Iss_S5Cam27` varchar(18) DEFAULT NULL COMMENT 'Otros Ingresos',
  `Iss_S5Cam28` varchar(1) DEFAULT NULL COMMENT 'Titular',
  `Iss_S6Cam1` varchar(16) DEFAULT NULL COMMENT 'Usuario de CMS',
  `Iss_S6Cam2` varchar(16) DEFAULT NULL COMMENT 'Contraseña cifrada del usuario en el sistema CMS',
  `Iss_S6Cam3` varchar(7) DEFAULT NULL COMMENT 'Consecutivo para todos los registros que no son header y trailer',
  `Iss_S6Cam4` varchar(9) DEFAULT NULL COMMENT 'Agrupador para indicar los registros que pertencen a un movimiento: Alta o Modificacion',
  `Iss_S6Cam5` varchar(4) DEFAULT NULL COMMENT 'Codigo De mensaje',
  `Iss_S6Cam6` varchar(4) DEFAULT NULL COMMENT 'Emisor Se revisa contra la tabla de emisores.',
  `Iss_S6Cam7` varchar(5) DEFAULT NULL COMMENT 'Numero de sucursal que tendrá asociada la solicitud de alta o que tiene asignado ya un registro',
  `Iss_S6Cam8` varchar(2) DEFAULT NULL COMMENT 'Producto valido para el Emisor.',
  `Iss_S6Cam9` varchar(30) DEFAULT NULL COMMENT 'ID del banco de clientes',
  `Iss_S6Cam10` varchar(2) DEFAULT NULL COMMENT 'Tipo de documento del titular de la tarjeta',
  `Iss_S6Cam11` varchar(15) DEFAULT NULL COMMENT 'Numero de documento del titular de la tarjeta',
  `Iss_S6Cam12` varchar(19) DEFAULT NULL COMMENT 'Numero de Pamcard.',
  `Iss_S6Cam13` varchar(9) DEFAULT NULL COMMENT 'Nombre corto del banco',
  `Iss_S6Cam14` varchar(9) DEFAULT NULL COMMENT 'Agencia.',
  `Iss_S6Cam15` varchar(30) DEFAULT NULL COMMENT 'Cuenta del CBS',
  `Iss_S6Cam16` varchar(3) DEFAULT NULL COMMENT 'Codigo de Moneda',
  `Iss_S6Cam17` varchar(80) DEFAULT NULL COMMENT 'Datos adicionales de la cuenta',
  `Iss_S6Cam18` varchar(18) DEFAULT NULL COMMENT 'El sobregiro permitido',
  `Iss_S6Cam19` varchar(2) DEFAULT NULL COMMENT 'Tipo de cuenta CBS',
  `Iss_S7Cam1` varchar(16) DEFAULT NULL COMMENT 'Usuario de CMS',
  `Iss_S7Cam2` varchar(16) DEFAULT NULL COMMENT 'Contraseña cifrada del usuario en el sistema CMS',
  `Iss_S7Cam3` varchar(7) DEFAULT NULL COMMENT 'Consecutivo para todos los registros que no son header y trailer',
  `Iss_S7Cam4` varchar(9) DEFAULT NULL COMMENT 'Agrupador para indicar los registros que pertencen a un movimiento: Alta o Modificacion',
  `Iss_S7Cam5` varchar(4) DEFAULT NULL COMMENT 'Codigo De mensaje',
  `Iss_S7Cam6` varchar(4) DEFAULT NULL COMMENT 'Emisor Se revisa contra la tabla de emisores.',
  `Iss_S7Cam7` varchar(5) DEFAULT NULL COMMENT 'Numero de sucursal que tendrá asociada la solicitud de alta o que tiene asignado ya un registro',
  `Iss_S7Cam8` varchar(2) DEFAULT NULL COMMENT 'Producto valido para el Emisor.',
  `Iss_S7Cam9` varchar(30) DEFAULT NULL COMMENT 'ID del banco de clientes',
  `Iss_S7Cam10` varchar(2) DEFAULT NULL COMMENT 'Tipo de documento del titular de la tarjeta',
  `Iss_S7Cam11` varchar(15) DEFAULT NULL COMMENT 'Numero de documento del titular de la tarjeta',
  `Iss_S7Cam12` varchar(19) DEFAULT NULL COMMENT 'Numero de Pamcard.',
  `Iss_S7Cam13` varchar(18) DEFAULT NULL COMMENT 'Cantidad de efectivo diario',
  `Iss_S7Cam14` varchar(18) DEFAULT NULL COMMENT 'monto maximo para reitiros en ATM por dia',
  `Iss_S7Cam15` varchar(18) DEFAULT NULL COMMENT 'monto maximo para reitiros en POS por semana',
  `Iss_S7Cam16` varchar(18) DEFAULT NULL COMMENT 'monto maximo para reitiros en POS por semana',
  `Iss_S7Cam17` varchar(18) DEFAULT NULL COMMENT 'monto maximo para reitiros en ATM por semana',
  `Iss_S7Cam18` varchar(18) DEFAULT NULL COMMENT 'monto maximo para reitiros en POS por mes',
  `Iss_S7Cam19` varchar(9) DEFAULT NULL COMMENT 'monto maximo para reitiros en ATM por mes',
  `Iss_S7Cam20` varchar(9) DEFAULT NULL COMMENT 'Numero maximo de transacciones por dia en POS',
  `Iss_S7Cam21` varchar(9) DEFAULT NULL COMMENT 'Numero maximo de transacciones por dia en ATM',
  `Iss_S7Cam22` varchar(9) DEFAULT NULL COMMENT 'Numero maximo de transacciones por semana  en POS',
  `Iss_S7Cam23` varchar(9) DEFAULT NULL COMMENT 'Numero maximo de transacciones por semana  en ATM',
  `Iss_S7Cam24` varchar(9) DEFAULT NULL COMMENT 'Numero maximo de transacciones por semana  en POS',
  `Iss_S7Cam25` varchar(18) DEFAULT NULL COMMENT 'Numero maximo de transacciones por semana  en ATM',
  `Iss_S7Cam26` varchar(50) DEFAULT NULL COMMENT 'Monto maximo de devolucion',
  `Iss_S8Cam1` varchar(16) DEFAULT NULL COMMENT 'Usuario de CMS',
  `Iss_S8Cam2` varchar(16) DEFAULT NULL COMMENT 'Contraseña cifrada del usuario en el sistema CMS',
  `Iss_S8Cam3` varchar(7) DEFAULT NULL COMMENT 'Consecutivo para todos los registros que no son header y trailer',
  `Iss_S8Cam4` varchar(9) DEFAULT NULL COMMENT 'Agrupador para indicar los registros que pertencen a un movimiento: Alta o Modificacion',
  `Iss_S8Cam5` varchar(4) DEFAULT NULL COMMENT 'Codigo De mensaje',
  `Iss_S8Cam6` varchar(4) DEFAULT NULL COMMENT 'Emisor Se revisa contra la tabla de emisores.',
  `Iss_S8Cam7` varchar(5) DEFAULT NULL COMMENT 'Numero de sucursal que tendrá asociada la solicitud de alta o que tiene asignado ya un registro',
  `Iss_S8Cam8` varchar(2) DEFAULT NULL COMMENT 'Producto valido para el Emisor.',
  `Iss_S8Cam9` varchar(30) DEFAULT NULL COMMENT 'ID del banco de clientes',
  `Iss_S8Cam10` varchar(2) DEFAULT NULL COMMENT 'Tipo de documento del titular de la tarjeta',
  `Iss_S8Cam11` varchar(15) DEFAULT NULL COMMENT 'Numero de documento del titular de la tarjeta',
  `Iss_S8Cam12` varchar(19) DEFAULT NULL COMMENT 'Numero de Pamcard.',
  `Iss_S8Cam13` varchar(3) DEFAULT NULL COMMENT 'Codigo de moneda de la transaccion.',
  `Iss_S8Cam14` varchar(9) DEFAULT NULL COMMENT 'Descripcion o diferenciador del banco ',
  `Iss_S8Cam15` varchar(9) DEFAULT NULL COMMENT 'Agencia del banco.',
  `Iss_S8Cam16` varchar(30) DEFAULT NULL COMMENT 'Cuenta del CBS  ligado a la tarjeta.',
  `Iss_S8Cam17` varchar(3) DEFAULT NULL COMMENT 'Moneda de la cuenta bancaria de CBS',
  `Iss_S8Cam18` varchar(2) DEFAULT NULL COMMENT 'Tipo de Cuenta de CBS',
  `Iss_S8Cam19` varchar(1) DEFAULT NULL COMMENT 'Operaciocnes con mas de una cuenta que tiene ligada',
  `Iss_S9Cam1` varchar(7) DEFAULT NULL COMMENT 'Identificacion de registro de encabezado.',
  `Iss_S9Cam2` varchar(3) DEFAULT NULL COMMENT 'Indica la aplicacion procedente de un Usuario.',
  `Iss_S9Cam3` varchar(5) DEFAULT NULL COMMENT 'Codigo de Usuario PROSA',
  `Iss_S9Cam4` varchar(4) DEFAULT NULL COMMENT 'Tipo de archivo Tarjeta',
  `Iss_S9Cam5` varchar(2) DEFAULT NULL COMMENT 'Periodicidad del archivo',
  `Iss_S9Cam6` varchar(6) DEFAULT NULL COMMENT 'Consecutivo de archivos enviados',
  `Iss_S9Cam7` varchar(4) DEFAULT NULL COMMENT 'Extension .IN',
  `Iss_S9Cam8` varchar(12) DEFAULT NULL COMMENT 'Fecha de creacion del archivo',
  `Iss_S9Cam9` varchar(8) DEFAULT NULL COMMENT 'Usuario',
  `Iss_S9Cam10` varchar(16) DEFAULT NULL COMMENT 'Contraseña',
  `Iss_S9Cam11` varchar(9) DEFAULT NULL COMMENT 'Suma de todos los registros',
  `Iss_S9Cam12` varchar(6) DEFAULT NULL COMMENT 'Identificacion del remitente.',
  `Iss_Orden` bigint(20) DEFAULT NULL COMMENT 'Orden Archivo.',
  `Iss_Registro` text COMMENT 'RegistroID ISS',
  `Iss_ConsecDoc` decimal(15,0) DEFAULT NULL COMMENT 'Consecutivo del Documento ISS',
  KEY `Idx_TCARCISS_Iss_FolioAr` (`Iss_FolioAr`),
  KEY `INDEX_TCR_TCARCISS_ADM2` (`Iss_Seccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Genera  el contenido del archivo ISS'$$