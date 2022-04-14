//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, vJAXB 2.1.10 in JDK 6 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2014.11.28 at 01:58:23 PM CST 
//



package contabilidad.bean;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlSchemaType;
import javax.xml.bind.annotation.XmlType;
import javax.xml.datatype.XMLGregorianCalendar;


@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "", propOrder = {
    "poliza"
})
@XmlRootElement(name = "PLZ:Polizas", namespace = "http://www.sat.gob.mx/polizas")
public class ContaElecPolizasBean {

    @XmlElement(name = "PLZ:Poliza", namespace = "http://www.sat.gob.mx/polizas",required = true)
	public List<ContaElecPolizasBean.Poliza> poliza;
    @XmlAttribute(name = "Ano", required = true)
    protected int ano;
    @XmlAttribute(name = "Mes", required = true)
    protected String mes;
    @XmlAttribute(name = "RFC", required = true)
    protected String rfc;
    @XmlAttribute(name = "Version", required = true)
    protected String version;




    
    public List<ContaElecPolizasBean.Poliza> getPoliza() {
        if (poliza == null) {
            poliza = new ArrayList<ContaElecPolizasBean.Poliza>();
        }
        return this.poliza;
    }

   
    public String getVersion() {
        if (version == null) {
            return "1.0";
        } else {
            return version;
        }
    }

   
    public void setVersion(String value) {
        this.version = value;
    }

    
    public String getRFC() {
        return rfc;
    }

   
    public void setRFC(String value) {
        this.rfc = value;
    }

    
    public String getMes() {
        return mes;
    }

    
    public void setMes(String value) {
        this.mes = value;
    }

    
    public int getAno() {
        return ano;
    }

   
    public void setAno(int value) {
        this.ano = value;
    }


    
    @XmlAccessorType(XmlAccessType.FIELD)
    @XmlType(name = "", propOrder = {
        "transaccion"
    })
    public static class Poliza {

        @XmlElement(name = "PLZ:Transaccion", required = true)
		public List<ContaElecPolizasBean.Poliza.Transaccion> transaccion;
        @XmlAttribute(name = "Concepto", required = true)
        protected String concepto;
        @XmlAttribute(name = "Fecha", required = true)
        @XmlSchemaType(name = "date")
        protected String fecha;
        @XmlAttribute(name = "Num", required = true)
        protected String num;
        @XmlAttribute(name = "Tipo", required = true)
        protected int tipo;


       
        public List<ContaElecPolizasBean.Poliza.Transaccion> getTransaccion() {
            if (transaccion == null) {
                transaccion = new ArrayList<ContaElecPolizasBean.Poliza.Transaccion>();
            }
            return this.transaccion;
        }

        
        public int getTipo() {
            return tipo;
        }

       
        public void setTipo(int value) {
            this.tipo = value;
        }

       
        public String getNum() {
            return num;
        }

        
        public void setNum(String value) {
            this.num = value;
        }

       
        public String getFecha() {
            return fecha;
        }

       
        public void setFecha(String value) {
            this.fecha = value;
        }


        public String getConcepto() {
            return concepto;
        }


        public void setConcepto(String value) {
            this.concepto = value;
        }



        @XmlAccessorType(XmlAccessType.FIELD)
        @XmlType(name = "", propOrder = {
            "cheque",
            "transferencia",
            "comprobantes"
        })
        public static class Transaccion {

            @XmlElement(name = "Cheque")
            protected List<ContaElecPolizasBean.Poliza.Transaccion.Cheque> cheque;
            @XmlElement(name = "Transferencia")
            protected List<ContaElecPolizasBean.Poliza.Transaccion.Transferencia> transferencia;
            @XmlElement(name = "PLZ:Comprobantes")
			public List<ContaElecPolizasBean.Poliza.Transaccion.Comprobantes> comprobantes;
            @XmlAttribute(name = "TipCamb")
            protected BigDecimal tipCamb;
            @XmlAttribute(name = "Moneda", required = true)
            protected String moneda;
            @XmlAttribute(name = "Haber", required = true)
            protected BigDecimal haber;
            @XmlAttribute(name = "Debe", required = true)
            protected BigDecimal debe;
            @XmlAttribute(name = "Concepto", required = true)
            protected String concepto;            
            @XmlAttribute(name = "NumCta", required = true)
            protected String numCta;





            
            public List<ContaElecPolizasBean.Poliza.Transaccion.Cheque> getCheque() {
                if (cheque == null) {
                    cheque = new ArrayList<ContaElecPolizasBean.Poliza.Transaccion.Cheque>();
                }
                return this.cheque;
            }

           
            public List<ContaElecPolizasBean.Poliza.Transaccion.Transferencia> getTransferencia() {
                if (transferencia == null) {
                    transferencia = new ArrayList<ContaElecPolizasBean.Poliza.Transaccion.Transferencia>();
                }
                return this.transferencia;
            }

            
            public List<ContaElecPolizasBean.Poliza.Transaccion.Comprobantes> getComprobantes() {
                if (comprobantes == null) {
                    comprobantes = new ArrayList<ContaElecPolizasBean.Poliza.Transaccion.Comprobantes>();
                }
                return this.comprobantes;
            }

            
            public String getNumCta() {
                return numCta;
            }

           
            public void setNumCta(String value) {
                this.numCta = value;
            }

            
            public String getConcepto() {
                return concepto;
            }

            
            public void setConcepto(String value) {
                this.concepto = value;
            }


            public BigDecimal getDebe() {
                return debe;
            }


            public void setDebe(BigDecimal value) {
                this.debe = value;
            }


            public BigDecimal getHaber() {
                return haber;
            }


            public void setHaber(BigDecimal value) {
                this.haber = value;
            }

            
            public String getMoneda() {
                return moneda;
            }

            
            public void setMoneda(String value) {
                this.moneda = value;
            }

            
            public BigDecimal getTipCamb() {
                return tipCamb;
            }

            
            public void setTipCamb(BigDecimal value) {
                this.tipCamb = value;
            }


            
            @XmlAccessorType(XmlAccessType.FIELD)
            @XmlType(name = "")
            public static class Cheque {

                @XmlAttribute(name = "Num", required = true)
                protected String num;
                @XmlAttribute(name = "Banco", required = true)
                protected String banco;
                @XmlAttribute(name = "CtaOri", required = true)
                protected String ctaOri;
                @XmlAttribute(name = "Fecha", required = true)
                @XmlSchemaType(name = "date")
                protected XMLGregorianCalendar fecha;
                @XmlAttribute(name = "Monto", required = true)
                protected BigDecimal monto;
                @XmlAttribute(name = "Benef", required = true)
                protected String benef;
                @XmlAttribute(name = "RFC", required = true)
                protected String rfc;

                
                public String getNum() {
                    return num;
                }

                
                public void setNum(String value) {
                    this.num = value;
                }

                
                public String getBanco() {
                    return banco;
                }

                
                public void setBanco(String value) {
                    this.banco = value;
                }

               
                public String getCtaOri() {
                    return ctaOri;
                }

               
                public void setCtaOri(String value) {
                    this.ctaOri = value;
                }

                
                public XMLGregorianCalendar getFecha() {
                    return fecha;
                }

                
                public void setFecha(XMLGregorianCalendar value) {
                    this.fecha = value;
                }

                
                public BigDecimal getMonto() {
                    return monto;
                }

               
                public void setMonto(BigDecimal value) {
                    this.monto = value;
                }

                
                public String getBenef() {
                    return benef;
                }

               
                public void setBenef(String value) {
                    this.benef = value;
                }

                
                public String getRFC() {
                    return rfc;
                }

                
                public void setRFC(String value) {
                    this.rfc = value;
                }

            }


            
            @XmlAccessorType(XmlAccessType.FIELD)
            @XmlType(name = "")
            public static class Comprobantes {
                @XmlAttribute(name = "RFC", required = true)
                protected String rfc;
                @XmlAttribute(name = "Monto", required = true)
                protected BigDecimal monto;
                @XmlAttribute(name = "UUID_CFDI", required = true)
                protected String uuidcfdi;


                
                public String getUUIDCFDI() {
                    return uuidcfdi;
                }

                
                public void setUUIDCFDI(String value) {
                    this.uuidcfdi = value;
                }

                
                public BigDecimal getMonto() {
                    return monto;
                }

               
                public void setMonto(BigDecimal value) {
                    this.monto = value;
                }

                
                public String getRFC() {
                    return rfc;
                }

                
                public void setRFC(String value) {
                    this.rfc = value;
                }

            }


            
            @XmlAccessorType(XmlAccessType.FIELD)
            @XmlType(name = "")
            public static class Transferencia {

                @XmlAttribute(name = "CtaOri", required = true)
                protected String ctaOri;
                @XmlAttribute(name = "BancoOri", required = true)
                protected String bancoOri;
                @XmlAttribute(name = "Monto", required = true)
                protected BigDecimal monto;
                @XmlAttribute(name = "CtaDest", required = true)
                protected String ctaDest;
                @XmlAttribute(name = "BancoDest", required = true)
                protected String bancoDest;
                @XmlAttribute(name = "Fecha", required = true)
                @XmlSchemaType(name = "date")
                protected XMLGregorianCalendar fecha;
                @XmlAttribute(name = "Benef", required = true)
                protected String benef;
                @XmlAttribute(name = "RFC", required = true)
                protected String rfc;

               
                public String getCtaOri() {
                    return ctaOri;
                }

                
                public void setCtaOri(String value) {
                    this.ctaOri = value;
                }

               
                public String getBancoOri() {
                    return bancoOri;
                }

                
                public void setBancoOri(String value) {
                    this.bancoOri = value;
                }

                
                public BigDecimal getMonto() {
                    return monto;
                }

                
                public void setMonto(BigDecimal value) {
                    this.monto = value;
                }

                
                public String getCtaDest() {
                    return ctaDest;
                }

                
                public void setCtaDest(String value) {
                    this.ctaDest = value;
                }

                
                public String getBancoDest() {
                    return bancoDest;
                }

                
                public void setBancoDest(String value) {
                    this.bancoDest = value;
                }

                
                public XMLGregorianCalendar getFecha() {
                    return fecha;
                }

                
                public void setFecha(XMLGregorianCalendar value) {
                    this.fecha = value;
                }

                
                public String getBenef() {
                    return benef;
                }

                
                public void setBenef(String value) {
                    this.benef = value;
                }

                
                public String getRFC() {
                    return rfc;
                }

                
                public void setRFC(String value) {
                    this.rfc = value;
                }

            }

        }

    }

}