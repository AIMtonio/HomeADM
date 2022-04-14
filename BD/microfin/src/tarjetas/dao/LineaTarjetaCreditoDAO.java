package tarjetas.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;


import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import tarjetas.bean.LineaTarjetaCreditoBean;

public class LineaTarjetaCreditoDAO extends BaseDAO  {
	

	public LineaTarjetaCreditoDAO() {
		super();
	}
	
	public List listaLineasCliTodas(LineaTarjetaCreditoBean lineaTarjetaCreditoBean, int tipoLista){
		String query = "call LINEATARJETACREDLIS(?,?,?,   ?,?,?,?,?,?,?);";
		Object[] parametros = {	Constantes.STRING_VACIO,
								Utileria.convierteEntero(lineaTarjetaCreditoBean.getClienteID()),
								tipoLista,
								
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call LINEATARJETACREDLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				LineaTarjetaCreditoBean lineaTarjetaCreditoBean = new LineaTarjetaCreditoBean();
				lineaTarjetaCreditoBean.setLineaTarCredID(Utileria.completaCerosIzquierda(resultSet.getString("LineaTarCredID"),LineaTarjetaCreditoBean.LONGITUD_ID));
				lineaTarjetaCreditoBean.setDescripcion(resultSet.getString("Descripcion"));//devuelve la descripcion de la cuenta de ahorro			
				return lineaTarjetaCreditoBean;
			}
		});
		return matches;
	}


	
	
	public List listaCtasCliente(LineaTarjetaCreditoBean lineaTarjetaCreditoBean, int tipoLista){
		String query = "call LINEATARJETACREDLIS(?,?,?,   ?,?,?,?,?,?,?);";
		Object[] parametros = {	lineaTarjetaCreditoBean.getNomCompleto(),
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
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call LINEATARJETACREDLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				LineaTarjetaCreditoBean lineaTarjetaCreditoBean = new LineaTarjetaCreditoBean();
				lineaTarjetaCreditoBean.setLineaTarCredID(Utileria.completaCerosIzquierda(resultSet.getString("LineaTarCredID"),LineaTarjetaCreditoBean.LONGITUD_ID));
				lineaTarjetaCreditoBean.setDescripcion(resultSet.getString("Descripcion"));//devuelve la descripcion de la cuenta de ahorro			
				return lineaTarjetaCreditoBean;
			}
		});
		return matches;
	}

	
	
	
	/* Consulta de linea de credito*/
	public LineaTarjetaCreditoBean consultaLineaTarjetaCte(int tipoConsulta,LineaTarjetaCreditoBean lineaTarjetaCreditoBean){
		
		String query = "call LINEATARJETACREDCON(?,?,?,?,   ?,?,?,?,?,?,?);";
	
		Object[] parametros = {
				Constantes.ENTERO_CERO,
				lineaTarjetaCreditoBean.getClienteID(),
				lineaTarjetaCreditoBean.getTipoTarjetaDeb(),
				tipoConsulta,
				
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"LineaTarjetaCreditoDAO.consultaLineaTarjetaCte",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call LINEATARJETACREDCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				LineaTarjetaCreditoBean lineaTarjeta= new LineaTarjetaCreditoBean();

				lineaTarjeta.setLineaTarCredID(
				 (resultSet.getString("LineatarCredID")!=null) ?
						   Utileria.completaCerosIzquierda(
								   Utileria.convierteEntero(resultSet.getString("LineatarCredID")
										   ),LineaTarjetaCreditoBean.LONGITUD_ID) : Constantes.STRING_VACIO  );
				lineaTarjeta.setTarjetaCredID(resultSet.getString("TarjetaCredID"));
				lineaTarjeta.setTipoPago(resultSet.getString("TipoPago"));
				lineaTarjeta.setDiaPago(resultSet.getString("DiaPago"));
				lineaTarjeta.setTipoCorte(resultSet.getString("TipoCorte"));
				lineaTarjeta.setDiaCorte(resultSet.getString("DiaCorte"));
				lineaTarjeta.setCuentaClabe(resultSet.getString("CuentaClabe"));
				lineaTarjeta.setEstatus(resultSet.getString("Estatus"));
					return lineaTarjeta;
			}
		});

		return matches.size() > 0 ? (LineaTarjetaCreditoBean) matches.get(0) : null;
	}	
	
	
	/* Consulta de linea de credito*/
	public LineaTarjetaCreditoBean consultaCorte(int tipoConsulta,LineaTarjetaCreditoBean lineaTarjetaCreditoBean){
		
		String query = "call LINEATARJETACREDCON(?,?,?,?,   ?,?,?,?,?,?,?);";
	
		Object[] parametros = {
				Constantes.ENTERO_CERO,
				lineaTarjetaCreditoBean.getClienteID(),
				lineaTarjetaCreditoBean.getTipoTarjetaDeb(),
				tipoConsulta,
				
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"LineaTarjetaCreditoDAO.ccon",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call LINEATARJETACREDCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				LineaTarjetaCreditoBean lineaTarjeta= new LineaTarjetaCreditoBean();
				lineaTarjeta.setSaldoInicial(resultSet.getString("SaldoInicial"));
				lineaTarjeta.setPagoNoGenInteres(resultSet.getString("PagoNoGenInteres"));
				lineaTarjeta.setPagoMinimo(resultSet.getString("PagoMinimo"));
				lineaTarjeta.setSaldoCorte(resultSet.getString("SaldoCorte"));
				lineaTarjeta.setFechaProxCorte(resultSet.getString("FechaProxCorte"));
					return lineaTarjeta;
			}
		});

		return matches.size() > 0 ? (LineaTarjetaCreditoBean) matches.get(0) : null;
	}	
	
		
}