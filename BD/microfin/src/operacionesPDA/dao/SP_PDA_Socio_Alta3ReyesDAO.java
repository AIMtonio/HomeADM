package operacionesPDA.dao;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import operacionesPDA.beanWS.request.SP_PDA_Socio_Alta3ReyesRequest;
import operacionesPDA.beanWS.response.SP_PDA_Socios_Alta3ReyesResponse;

public class SP_PDA_Socio_Alta3ReyesDAO extends BaseDAO{
	public SP_PDA_Socio_Alta3ReyesDAO() {
		super();
	}


	public SP_PDA_Socios_Alta3ReyesResponse socioAltaWS(final SP_PDA_Socio_Alta3ReyesRequest requestBean) {
		SP_PDA_Socios_Alta3ReyesResponse socioAlt = new SP_PDA_Socios_Alta3ReyesResponse();



		String nombres [] = requestBean.getNombre().toString().split(" ");

		String nombre1 = nombres[0];
	    requestBean.setNombre1(nombre1);


        if(nombres.length <2){
        String nombres2 = "";
        requestBean.setNombre2(nombres2);

        }

        else{
        String nombre2 = nombres[1];
        requestBean.setNombre2(nombre2);

        }


        if(nombres.length < 3){
        String nombres3 = "";
        requestBean.setNombre3(nombres3);

        }

        else{
        String nombre3 = nombres[2];
        requestBean.setNombre3(nombre3);

        }


				socioAlt = (SP_PDA_Socios_Alta3ReyesResponse) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			SP_PDA_Socios_Alta3ReyesResponse resultado = new SP_PDA_Socios_Alta3ReyesResponse();
			transaccionDAO.generaNumeroTransaccionWS();
			try {

						resultado = (SP_PDA_Socios_Alta3ReyesResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

							String query = "call CLIENTESWSALT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,"
			                        + "?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,"
			                        + "?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?  ,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								//sentenciaStore.setString("Par_NombreCliente",requestBean.getNombre());

					    		sentenciaStore.setString("Par_Nombre1",requestBean.getNombre1());
								sentenciaStore.setString("Par_Nombre2",requestBean.getNombre2());
								sentenciaStore.setString("Par_Nombre3",requestBean.getNombre3());

								sentenciaStore.setString("Par_ApellidoPat",requestBean.getApPaterno());
								sentenciaStore.setString("Par_ApellidoMat",requestBean.getApMaterno());
								sentenciaStore.setString("Par_FechaNac",requestBean.getFecNacimiento());
								sentenciaStore.setString("Par_Rfc",requestBean.getRfc());
								sentenciaStore.setString("Par_Curp",requestBean.getCurp());
								sentenciaStore.setDouble("Par_Monto",Utileria.convierteDoble(requestBean.getMonto()));
								sentenciaStore.setInt("Par_SucursalOri",Utileria.convierteEntero(requestBean.getSucursal()));
								sentenciaStore.setString("Par_Mail",requestBean.getMail());
								sentenciaStore.setInt("Par_PaisNaci",Utileria.convierteEntero(requestBean.getPaisDeNacimiento()));
								sentenciaStore.setInt("Par_EstadoId",Utileria.convierteEntero(requestBean.getEntiFedNacimiento()));
								sentenciaStore.setString("Par_Nacionalidad",requestBean.getNacionalidad());
								sentenciaStore.setInt("Par_PaisResi",Utileria.convierteEntero(requestBean.getPaisDeResidencia()));
								sentenciaStore.setString("Par_Sexo",requestBean.getSexo());
								sentenciaStore.setString("Par_Telefono",requestBean.getTelefonoParticular());
								sentenciaStore.setInt("Par_SectorGral",Utileria.convierteEntero(requestBean.getSectorGeneral()));
								sentenciaStore.setString("Par_ActividadBMX",requestBean.getActividadBMX());
								sentenciaStore.setLong("Par_ActividadFR",Utileria.convierteLong(requestBean.getActividadFR()));
								sentenciaStore.setInt("Par_PromotorIni",Utileria.convierteEntero(requestBean.getPromotorInicial()));
								sentenciaStore.setInt("Par_PromotorAct",Utileria.convierteEntero(requestBean.getPromotorActual()));
								sentenciaStore.setString("Par_EsMenor",requestBean.getEsMenor());
								sentenciaStore.setString("Par_Numero",requestBean.getNumero());
								sentenciaStore.setInt("Par_TipDireccion",Utileria.convierteEntero(requestBean.getTipoDeDireccion()));
								sentenciaStore.setInt("Par_EntidadFed",Utileria.convierteEntero(requestBean.getEntidadFederativa()));
								sentenciaStore.setInt("Par_Municipio",Utileria.convierteEntero(requestBean.getMunicipio()));
								sentenciaStore.setInt("Par_Localidad",Utileria.convierteEntero(requestBean.getLocalidad()));
								sentenciaStore.setInt("Par_Colonia",Utileria.convierteEntero(requestBean.getColonia()));
								sentenciaStore.setString("Par_Calle",requestBean.getCalle());
								sentenciaStore.setString("Par_NumDireccion",requestBean.getNumeroDireccion());
								sentenciaStore.setString("Par_CodigoPostal",requestBean.getCodigoPostal());
								sentenciaStore.setString("Par_Oficial",requestBean.getOficial());
								sentenciaStore.setString("Par_FolioIdentifi",requestBean.getFolio());
								sentenciaStore.setInt("Par_TipoIdentif",Utileria.convierteEntero(requestBean.getTipo()));
								sentenciaStore.setString("Par_EsOficial",requestBean.getEsOficial());
								sentenciaStore.setDate("Par_FechaExp",OperacionesFechas.conversionStrDate(requestBean.getFechaExpedicion()));
								sentenciaStore.setDate("Par_FechaVen",OperacionesFechas.conversionStrDate(requestBean.getFechaVencimiento()));

								sentenciaStore.setString("Par_Folio_Pda",requestBean.getFolio_Pda());
								sentenciaStore.setString("Par_Id_Usuario",requestBean.getId_Usuario());
								sentenciaStore.setString("Par_Clave",requestBean.getClave());
								sentenciaStore.setString("Par_Dispositivo",requestBean.getDispositivo());


								//Parametros de Auditoria
								sentenciaStore.setInt("Par_EmpresaID", Constantes.ENTERO_CERO);
								sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
								sentenciaStore.setString("Aud_FechaActual", Constantes.FECHA_VACIA);
								sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
								sentenciaStore.setString("Aud_ProgramaID", "operacionesPDA.WS.sociosAlta3ReyesWS");
								sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());


								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								SP_PDA_Socios_Alta3ReyesResponse respuestaBean = new SP_PDA_Socios_Alta3ReyesResponse();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();

									respuestaBean.setAutFecha(resultadosStore.getString("AutFecha"));
									respuestaBean.setCodigoResp(resultadosStore.getString("CodigoResp"));
									respuestaBean.setCodigoDesc(resultadosStore.getString("CodigoDesc"));
									respuestaBean.setEsValido(resultadosStore.getString("EsValido"));
									respuestaBean.setFolioAut(resultadosStore.getString("FolioAut"));
									respuestaBean.setNumSocio(resultadosStore.getString("NumSocio"));

								}else{
									DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
									DateFormat timeFormat = new SimpleDateFormat("HH:mm:ss");
									Date fecha = new Date();
									respuestaBean.setAutFecha(dateFormat.format(fecha)+"T"+timeFormat.format(fecha));
									respuestaBean.setCodigoResp(String.valueOf(Constantes.ENTERO_CERO));
									respuestaBean.setCodigoDesc("Transacción Rechazada");
									respuestaBean.setEsValido("false");
									respuestaBean.setFolioAut(String.valueOf(Constantes.ENTERO_CERO));
									respuestaBean.setNumSocio(String.valueOf(Constantes.ENTERO_CERO));


								}
								return respuestaBean;
							}
						}
					);

					if(resultado ==  null){
						resultado = new SP_PDA_Socios_Alta3ReyesResponse();
						DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
						DateFormat timeFormat = new SimpleDateFormat("HH:mm:ss");
						Date fecha = new Date();
						resultado.setAutFecha(dateFormat.format(fecha)+"T"+timeFormat.format(fecha));
						resultado.setCodigoResp(String.valueOf(Constantes.ENTERO_CERO));
						resultado.setCodigoDesc("Transacción Rechazada");
						resultado.setEsValido("false");
						resultado.setFolioAut(String.valueOf(Constantes.ENTERO_CERO));
						resultado.setNumSocio(String.valueOf(Constantes.ENTERO_CERO));


						throw new Exception(Constantes.MSG_ERROR + " .SP_PDA_Socio_Alta3ReyesDAO.socioAltaWS");

					}else if(Integer.parseInt(resultado.getCodigoResp())!=1){
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error No. " + resultado.getCodigoResp() + ", " +resultado.getCodigoDesc());
						throw new Exception("Transacción Rechazada");
					}

				} catch (Exception e) {

					if (Integer.parseInt(resultado.getCodigoResp())==1) {

						resultado.setCodigoResp("0");
					}

					DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
					DateFormat timeFormat = new SimpleDateFormat("HH:mm:ss");
					Date fecha = new Date();
					resultado.setAutFecha(dateFormat.format(fecha)+"T"+timeFormat.format(fecha));
					resultado.setCodigoResp(String.valueOf(Constantes.ENTERO_CERO));
					resultado.setCodigoDesc(e.getMessage());
					resultado.setEsValido("false");
					resultado.setFolioAut(String.valueOf(Constantes.ENTERO_CERO));
					resultado.setNumSocio(String.valueOf(Constantes.ENTERO_CERO));

					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el alta de socio con  WS", e);
				}
				return resultado;
		}});

		return socioAlt;
	}

}
