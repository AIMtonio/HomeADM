package tesoreria.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.jdbc.core.JdbcTemplate;
 
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;

import bancaEnLinea.beanWS.request.ConsultaSaldoBloqueoBERequest;

import credito.beanWS.response.ConsultaDescuentosNominaResponse;

import tesoreria.bean.BloqueoBean;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;


public class BloqueoDAO extends BaseDAO{

	public List listaPrincipal(BloqueoBean bloqueo, int tipoLista){
		
		String query = "call BLOQUEOSLIS(?,?,?,?, ?,?,?,?,?,?,?);";
		
		Object[] parametros = {
                   	Utileria.convierteLong(bloqueo.getCuentaAhoID()),
                   	Utileria.convierteEntero(bloqueo.getMes()),
                   	Utileria.convierteEntero(bloqueo.getAnio()),
                	tipoLista,
					
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BLOQUEOSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				BloqueoBean bloqueos = new BloqueoBean();
				bloqueos.setCuentaAhoID(String.valueOf(resultSet.getString(1)));
				bloqueos.setNatMovimiento(resultSet.getString(2));
				bloqueos.setFechaMov(resultSet.getString(3));
				bloqueos.setMontoBloq(resultSet.getString(4));
				bloqueos.setDescripcion(resultSet.getString(5));
				bloqueos.setSaldoActual(resultSet.getString(6));
	
				return bloqueos;
			}
		});
		return matches;
	}
	
	// Lista de Saldos Bloqueados 
	public List listaSaldoBloq(BloqueoBean bloqueo, int tipoLista){
		
		String query = "call BLOQUEOSLIS(?,?,?,?, ?,?,?,?,?,?,?);";
		
		Object[] parametros = {
                   	Utileria.convierteLong(bloqueo.getCuentaAhoID()),
                   	Constantes.ENTERO_CERO,
                   	Constantes.ENTERO_CERO,
                	tipoLista,
					
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BLOQUEOSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				BloqueoBean bloqueos = new BloqueoBean();
				bloqueos.setBloqueoID(String.valueOf(resultSet.getInt("BloqueoID")));
				bloqueos.setCuentaAhoID(String.valueOf(resultSet.getString("CuentaAhoID")));
				bloqueos.setDescripcionCta(resultSet.getString("DescripcionCta"));
				bloqueos.setNatMovimiento(resultSet.getString("NatMovimiento"));
				bloqueos.setMontoBloq(resultSet.getString("MontoBloq"));
				bloqueos.setTiposBloqID(resultSet.getString("TiposBloqID"));
				bloqueos.setDescripcion(resultSet.getString("Descripcion"));
				bloqueos.setReferencia(resultSet.getString("Referencia"));
				bloqueos.setSaldoDispon(resultSet.getString("SaldoDispon"));
				bloqueos.setSaldoSBC(resultSet.getString("SaldoSBC"));
				bloqueos.setFechaMov(resultSet.getString("FechaMov"));
				return bloqueos;
			}
		});
		return matches;
	}
	
	
	// Lista de saldos bloquedos Banca en Linea
	public List listaSaldosBloqueadosWS(ConsultaSaldoBloqueoBERequest consultaSaldoBloqueoRequest){
		final ConsultaDescuentosNominaResponse mensajeBean = new ConsultaDescuentosNominaResponse();
String query = "call BLOQUEOSLIS(?,?,?,?, ?,?,?,?,?,?,?);";
		
		Object[] parametros = {
                   	Utileria.convierteLong(consultaSaldoBloqueoRequest.getCuentaAhoID()),
                 	Utileria.convierteEntero(consultaSaldoBloqueoRequest.getMes()),
                 	Utileria.convierteEntero(consultaSaldoBloqueoRequest.getAnio()),
                  	Utileria.convierteEntero(consultaSaldoBloqueoRequest.getTipoLis()),
					
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BLOQUEOSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				BloqueoBean bloqueos = new BloqueoBean();
				
			
				bloqueos.setCuentaAhoID(resultSet.getString(1));
				bloqueos.setNatMovimiento(resultSet.getString(2));
				bloqueos.setFechaMov(resultSet.getString(3));
				bloqueos.setDescripcion(resultSet.getString(5));
				bloqueos.setMontoBloq(resultSet.getString(4));
				bloqueos.setAuxMonto(resultSet.getString(6));
				return bloqueos;
			}
	});
		return matches;
	}
/*---------consultas--------*/
	
	public BloqueoBean consultaPrincipal(BloqueoBean bloqueo, int tipoConsulta) {
		// TODO Auto-generated method stub
		String query = "call BLOQUEOSCON(?,?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = { 
							(bloqueo.getBloqueoID() != null ) ? bloqueo.getBloqueoID() : Constantes.ENTERO_CERO,
							(bloqueo.getReferencia() != null) ? bloqueo.getReferencia() : Constantes.ENTERO_CERO,
							bloqueo.getCuentaAhoID(),
							tipoConsulta,
							
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							Constantes.FECHA_VACIA,
							Constantes.STRING_VACIO,
							"BloqueoDAO.consultaPrincipal",
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BLOQUEOSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				BloqueoBean bloqueo = new BloqueoBean();
				bloqueo.setAuxMonto(resultSet.getString(1));
				return bloqueo;
			}
		});
		return matches.size() > 0 ? (BloqueoBean) matches.get(0) : null;
	}	
}

