package ventanilla.dao;

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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
import ventanilla.bean.RemesasPagadasBean;

public class RemesasPagadasDAO extends BaseDAO {

	public RemesasPagadasDAO() {
		super();
	}

	public List<RemesasPagadasBean> consultaReremesas(String referencia, final int tipoConsulta) {
		String strQuery = "call PAGOREMESASCON (?,?,?,?,?,?,?,?,?);";

		Object[] parametros = new Object[9];

		parametros[0] = referencia;
		parametros[1] = tipoConsulta;
		parametros[2] = Constantes.ENTERO_CERO;
		parametros[3] = Constantes.ENTERO_CERO;
		parametros[4] = Constantes.FECHA_VACIA;
		parametros[5] = Constantes.STRING_VACIO;
		parametros[6] = "RemesasPagadasDAO.consultaReferencia";
		parametros[7] = Constantes.ENTERO_CERO;
		parametros[8] = Constantes.ENTERO_CERO;

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PAGOREMESASCON(" + Arrays.toString(parametros) + ")");
		
		List<RemesasPagadasBean> matches= ((JdbcTemplate)conexionOrigenDatosBean
				.getOrigenDatosMapa()
				.get(parametrosAuditoriaBean.getOrigenDatos()))
				.query(strQuery,parametros,new RowMapper<RemesasPagadasBean>() {
			public RemesasPagadasBean mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				RemesasPagadasBean remesa = new RemesasPagadasBean();
				if (tipoConsulta == 2) {
					remesa.setReferencia(resultSet.getString("RemesaFolio"));
					remesa.setRemesadora(resultSet.getString("NombreRemesadora"));
					remesa.setMonto(resultSet.getString("Monto"));
					remesa.setClienteID(resultSet.getInt("ClienteID"));
					remesa.setCliente(resultSet.getString("Cliente"));
					remesa.setUsuarioID(resultSet.getInt("UsuarioID"));
					remesa.setUsuario(resultSet.getString("Usuario"));
					remesa.setDireccion(resultSet.getString("Direccion"));
					remesa.setNumeroTelefono(resultSet.getString("NumTelefono"));
					remesa.setFormaPago(resultSet.getString("FormaPago"));
					remesa.setNumeroTrasnaccion(resultSet.getString("NumTransaccion"));
					remesa.setMoneda(resultSet.getString("moneda"));
					remesa.setNumeroReimpresiones(resultSet.getInt("NumeroImpresiones"));
				} else if (tipoConsulta == 3) {
					remesa.setReferencia(resultSet.getString("RemesaFolio"));
					remesa.setNumeroTrasnaccion(resultSet.getString("NumTransaccion"));
					remesa.setDenominiacionID(resultSet.getInt("DenominacionID"));
					remesa.setMonto(resultSet.getString("Monto"));
					remesa.setCantidad(resultSet.getString("Cantidad"));
					remesa.setValor(resultSet.getInt("valor"));
				} else if (tipoConsulta == 4) {
					remesa.setReferencia(resultSet.getString("RemesaFolio"));
					remesa.setRemesadora(resultSet.getString("NombreRemesadora"));
					remesa.setMonto(resultSet.getString("Monto"));
				}
				
				return remesa;
			}
		});
		
		return matches;
	}

	public MensajeTransaccionBean reimpresionPagoRemesa(String referencia){
		String strQuery = "call PAGOREMESASMOD(?, ?,?,?,?,?,?,?);";
		Object[] parametros = new Object[8];
		transaccionDAO.generaNumeroTransaccion();
		parametros[0] = referencia;
		parametros[1] = parametrosAuditoriaBean.getEmpresaID();
		parametros[2] = parametrosAuditoriaBean.getUsuario();
		parametros[3] = parametrosAuditoriaBean.getFecha();
		parametros[4] = parametrosAuditoriaBean.getDireccionIP();
		parametros[5] = "RemesasPagadasDAO.reimpresionPagoRemesa";
		parametros[6] = parametrosAuditoriaBean.getSucursal();
		parametros[7] = parametrosAuditoriaBean.getNumeroTransaccion();
		
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PAGOREMESASCON(" + Arrays.toString(parametros) + ")");
		
		List<MensajeTransaccionBean> matches= ((JdbcTemplate)conexionOrigenDatosBean
				.getOrigenDatosMapa()
				.get(parametrosAuditoriaBean.getOrigenDatos()))
				.query(strQuery,parametros,new RowMapper<MensajeTransaccionBean>() {
			public MensajeTransaccionBean mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				mensaje.setNumero(resultSet.getInt("NumeroImpresiones"));
				mensaje.setDescripcion(resultSet.getString("RemesaFolio"));
				return mensaje;
			}
		});
		
		return matches.get(0);
	}
}