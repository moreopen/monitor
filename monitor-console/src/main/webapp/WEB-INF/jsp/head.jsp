<%@ page isELIgnored="false"%>
<meta http-equiv="Cache-Control" content="no-store"/>
<meta http-equiv="Pragma" content="no-cache"/>
<meta http-equiv="Expires" content="0"/>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script type="text/javascript" src="/feed/js/jquery-1.5.1.js"></script>
<script type="text/javascript" src="/feed/js/common.js"></script>
<script type="text/javascript" src="/feed/js/outbox.js"></script>
<script type="text/javascript" src="/feed/js/inbox.js"></script>
<script type="text/javascript" src="/feed/js/comment.js"></script>
<script type="text/javascript" src="/feed/js/date.js"></script>




 <style type="text/css">
        .pop-box
        {
            z-index: 9999;
            margin-bottom: fd3px;
            display: none;
            position: absolute;
            background: #ffffff;
            border: solid 1px #6e8bde;
        }
        .pop-box h4
        {
            color: #ffffff;
            cursor: default;
            height: 18px;
            font-size: 14px;
            font-weight: bold;
            text-align: left;
            padding-left: 8px;
            padding-top: 4px;
            padding-bottom: 2px;
        }
        .pop-box-body
        {
            clear: both;
            margin: 4px;
            padding: 2px;
        }
        .style1
        {
            width: 100%;
        }
        .style2
        {
            width: 80px;
        }
    </style>
    
