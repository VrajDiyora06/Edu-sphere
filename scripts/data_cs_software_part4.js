// scripts/data_cs_software_part4.js
// Courses 7-8: Computer Networks, Software Engineering and Testing

export const coursesPart4 = [
  // -------------------------------------------------------------------------
  // 7. Computer Networks
  // -------------------------------------------------------------------------
  {
    id: 'd0000000-0000-0000-0000-000000000007',
    title: 'Computer Networks',
    slug: 'computer-networks-principles',
    description: 'Comprehensive undergraduate computer networks curriculum: OSI 7-layer vs TCP/IP models, application protocols (HTTP/DNS), TCP reliability, sliding window, AIMD congestion control, IPv4/IPv6 CIDR subnetting, link-state routing, and network security.',
    category: 'Computer Science',
    level: 'Intermediate',
    thumbnail_url: 'https://images.unsplash.com/photo-1544197150-b99a580bb7a8?q=80&w=800&auto=format&fit=crop',
    lessons: [
      {
        id: 'd0000000-0000-0000-0107-000000000001',
        title: 'Layered Network Architectures: OSI 7-Layer vs TCP/IP 4-Layer Stacks',
        duration_minutes: 40,
        is_free_preview: true,
        order_index: 1,
        content: `### Learning Objectives
- Master the OSI 7-layer reference model and the practical TCP/IP 4-layer internet model.
- Trace packet encapsulation and decapsulation across layers: Data -> Segment -> Packet -> Frame -> Bits.
- Understand Protocol Data Units (PDUs), addressing schemes (Port, IP, MAC), and multiplexing.

### Layer Comparison Matrix
| OSI Layer | TCP/IP Layer | PDU Name | Addressing | Primary Protocols / Hardware |
| :--- | :--- | :--- | :--- | :--- |
| Application / Pres / Sess | Application | Message / Data | Process / Port | HTTP, DNS, SSH, TLS |
| Transport | Transport | Segment (TCP) / Datagram (UDP) | Port (16-bit) | TCP, UDP |
| Network | Internet | Packet / Datagram | IP Address (32/128-bit) | IPv4, IPv6, ICMP, Routers |
| Data Link | Link / Network Interface | Frame | MAC Address (48-bit) | Ethernet, 802.11 Wi-Fi, Switches |
| Physical | Link / Physical | Bit Stream | Signals / Voltage | Cables, Fiber, Hubs |

### Key Takeaways
- Encapsulation prepends layer-specific headers as data flows down the protocol stack; decapsulation strips headers as data ascends on the receiving host.
- Routers inspect headers up to Layer 3 (Network); Layer 2 switches inspect frames up to Layer 2 (Data Link).`
      },
      {
        id: 'd0000000-0000-0000-0107-000000000002',
        title: 'Application Layer Protocols: DNS Resolution, HTTP/HTTPS & Sockets',
        duration_minutes: 45,
        is_free_preview: false,
        order_index: 2,
        content: `### Learning Objectives
- Trace recursive and iterative DNS resolution hierarchies: Root, TLD, and Authoritative Nameservers.
- Understand DNS record types: \`A\`, \`AAAA\`, \`CNAME\`, \`MX\`, and \`TXT\`.
- Implement basic client-server socket communication over TCP and UDP.

### DNS Hierarchical Resolution Pipeline
\`\`\`
Browser Cache ---> OS Resolver ---> Local DNS Server (Recursive)
                                           |
    +--------------------------------------+------------------------------------+
    | (Iterative query)                    | (Iterative query)                  | (Iterative query)
    v                                      v                                    v
Root Nameserver (.)                TLD Nameserver (.com)              Authoritative Nameserver
(Returns TLD server IP)            (Returns Authoritative server IP)  (Returns final A record IP)
\`\`\`

### Key Takeaways
- DNS primarily utilizes UDP on Port 53 for low latency; zone transfers utilize TCP on Port 53 for reliability.
- Berkeley Sockets provide the universal OS abstraction for network programming using \`socket()\`, \`bind()\`, \`listen()\`, \`accept()\`, and \`connect()\`.`
      },
      {
        id: 'd0000000-0000-0000-0107-000000000003',
        title: 'Transport Layer Mechanics: UDP vs TCP & Connection Management',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 3,
        content: `### Learning Objectives
- Compare connectionless, unreliable UDP with connection-oriented, reliable TCP.
- Trace the TCP 3-Way Handshake (SYN -> SYN-ACK -> ACK) and 4-Way Connection Teardown (FIN -> ACK -> FIN -> ACK).
- Understand TCP header fields: Sequence numbers, Acknowledgment numbers, Flags, Window size, and Checksum.

### TCP 3-Way Handshake
\`\`\`
Client                                          Server
  | ----- SYN (seq = x) -------------------------> |  (Server allocates TCB buffer)
  | <---- SYN-ACK (seq = y, ack = x + 1) -------- |  (Client receives sequence verification)
  | ----- ACK (seq = x + 1, ack = y + 1) --------> |  (Connection ESTABLISHED)
\`\`\`

### The TIME_WAIT State
The host initiating a passive closure remains in \`TIME_WAIT\` for $2 \\cdot \\text{MSL}$ (Maximum Segment Lifetime, typically 2 minutes) to ensure the final ACK was received by the remote peer and prevent delayed duplicate packets from corrupting new connections.

### Key Takeaways
- TCP guarantees in-order byte stream delivery, error detection, flow control, and congestion control.
- UDP provides lightweight datagram transport with zero connection setup latency, ideal for real-time gaming, DNS, and live streaming.`
      },
      {
        id: 'd0000000-0000-0000-0107-000000000004',
        title: 'Flow Control & TCP Congestion Control: AIMD, Slow Start & Fast Recovery',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 4,
        content: `### Learning Objectives
- Differentiate Flow Control (preventing receiver buffer overflow) from Congestion Control (preventing network bottleneck collapse).
- Master TCP sliding window mechanics and Receiver Advertised Window (rwnd).
- Analyze the 4 phases of TCP Tahoe and Reno: Slow Start, Congestion Avoidance, Fast Retransmit, and Fast Recovery.

### Congestion Control State Machine (TCP Reno)
1. **Slow Start**: Congestion Window ($cwnd$) starts at 1 MSS and doubles exponentially every RTT ($cwnd = cwnd \\times 2$) until reaching $ssthresh$.
2. **Congestion Avoidance**: $cwnd$ grows linearly by 1 MSS per RTT (Additive Increase: $cwnd = cwnd + 1$).
3. **Triple Duplicate ACKs**: Indicates single packet loss without full timeout. Fast Retransmit triggers immediately; $ssthresh = cwnd / 2$, and $cwnd = ssthresh$ (Multiplicative Decrease).
4. **Timeout**: Catastrophic packet drop; $ssthresh = cwnd / 2$, and $cwnd$ resets to 1 MSS.

### Key Takeaways
- **AIMD** (Additive Increase Multiplicative Decrease) is mathematically stable and drives competing flows toward fair bandwidth sharing.
- Flow control uses \`rwnd\` feedback in TCP headers; congestion control dynamically estimates network capacity via \`cwnd\`.`
      },
      {
        id: 'd0000000-0000-0000-0107-000000000005',
        title: 'Network Layer: IPv4 Addressing, Subnetting, CIDR & NAT',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 5,
        content: `### Learning Objectives
- Deconstruct 32-bit IPv4 addresses into Network ID, Subnet ID, and Host ID.
- Calculate subnet masks, usable host ranges, and broadcast addresses using Classless Inter-Domain Routing (CIDR) notation.
- Understand Network Address Translation (NAT) and Private IP address ranges (RFC 1918).

### Subnetting Mathematical Formulas
For a subnet mask with $/n$ prefix length:
- **Host Bits**: $h = 32 - n$.
- **Total IP Addresses**: $2^h$.
- **Usable Host Addresses**: $2^h - 2$ (subtracting Network Address and Directed Broadcast Address).

\`\`\`
Address: 192.168.10.65 / 26
Prefix length: 26 bits -> 6 host bits (2^6 = 64 addresses per subnet)
Subnet Mask:   255.255.255.192
Network ID:    192.168.10.64
First Usable:  192.168.10.65
Last Usable:   192.168.10.126
Broadcast:     192.168.10.127
\`\`\`

### Key Takeaways
- CIDR replaced rigid Class A/B/C addressing with arbitrary prefix masking, preventing global routing table explosion.
- NAT allows thousands of private local IP addresses to share a single public IPv4 address using port translation (NAPT/PAT).`
      },
      {
        id: 'd0000000-0000-0000-0107-000000000006',
        title: 'Routing Protocols: Distance Vector, Link State (OSPF) & BGP',
        duration_minutes: 45,
        is_free_preview: false,
        order_index: 6,
        content: `### Learning Objectives
- Compare Interior Gateway Protocols (IGP) with Exterior Gateway Protocols (EGP).
- Contrast Distance Vector routing (Bellman-Ford, RIP) with Link State routing (Dijkstra, OSPF).
- Understand Border Gateway Protocol (BGP) autonomous system routing and path vector logic.

### Routing Algorithm Comparison
| Feature | Distance Vector (RIP) | Link State (OSPF) | Path Vector (BGP) |
| :--- | :--- | :--- | :--- |
| **Algorithm** | Bellman-Ford | Dijkstra\'s Shortest Path | Path Vector policy routing |
| **Knowledge** | Neighbors only ("routing by rumor") | Complete topology graph | AS-path attribute sequences |
| **Convergence** | Slow; count-to-infinity problem | Fast via Link State Advertisements (LSA) | Policy-governed |
| **Metric** | Hop count (max 15 hops) | Cost based on bandwidth | Business policies, AS hops |

### Key Takeaways
- OSPF routers flood LSAs so every router builds an identical topology database, running Dijkstra locally to find the shortest tree.
- BGP routes between Autonomous Systems (AS) across the global Internet backbone using policy rules rather than pure shortest-path metrics.`
      },
      {
        id: 'd0000000-0000-0000-0107-000000000007',
        title: 'Data Link Layer: Framing, Error Detection (CRC), MAC Addressing & ARP',
        duration_minutes: 45,
        is_free_preview: false,
        order_index: 7,
        content: `### Learning Objectives
- Formulate framing techniques: Byte stuffing and Bit stuffing.
- Calculate Cyclic Redundancy Checks (CRC) using polynomial modulo-2 arithmetic.
- Trace Address Resolution Protocol (ARP) mapping 32-bit IP addresses to 48-bit MAC addresses.

### Cyclic Redundancy Check (CRC) Polynomial Division
To compute an $r$-bit CRC checksum for a bit string $M$ using generator polynomial $G$:
1. Append $r$ zero bits to $M$.
2. Perform modulo-2 binary division (using XOR instead of subtraction) by $G$.
3. The remainder $R$ is the CRC checksum appended to the transmitted frame.
4. The receiver divides the received frame by $G$; a non-zero remainder proves transmission bit error.

### Key Takeaways
- Switches operate at Layer 2, maintaining dynamic MAC address tables via source MAC learning and frame flooding.
- ARP resolves local IP addresses to physical MAC hardware addresses via broadcast requests and unicast replies.`
      }
    ],
    quizzes: [
      {
        id: 'd0000000-0000-0000-0207-000000000001',
        title: 'OSI & TCP/IP Architecture & Layer Responsibilities Quiz',
        description: 'Tests knowledge of layer functions, protocol data units (PDUs), encapsulation, and port/IP/MAC addressing.',
        time_limit_minutes: 15,
        passing_score: 70,
        questions: [
          {
            id: 'd0000000-0000-0000-0307-000000000001',
            order_index: 1,
            marks: 10,
            question_text: 'What is the correct Protocol Data Unit (PDU) name at the Transport Layer of the OSI model?',
            options: ['Packet', 'Segment', 'Frame', 'Bit'],
            correct_option_index: 1,
            explanation: 'Layer 4 (Transport) PDUs are called Segments (in TCP) or Datagrams (in UDP); Layer 3 has Packets; Layer 2 has Frames.'
          },
          {
            id: 'd0000000-0000-0000-0307-000000000002',
            order_index: 2,
            marks: 10,
            question_text: 'Which layer of the OSI model is responsible for end-to-end process-to-process communication and port multiplexing?',
            options: ['Network Layer', 'Transport Layer', 'Data Link Layer', 'Session Layer'],
            correct_option_index: 1,
            explanation: 'The Transport Layer provides process-to-process communication using 16-bit port numbers to distinguish concurrent applications.'
          },
          {
            id: 'd0000000-0000-0000-0307-000000000003',
            order_index: 3,
            marks: 10,
            question_text: 'At what layer of the network stack does a standard Layer 2 Ethernet switch make forwarding decisions?',
            options: ['Physical Layer', 'Data Link Layer', 'Network Layer', 'Transport Layer'],
            correct_option_index: 1,
            explanation: 'Layer 2 switches inspect incoming frames, learn source MAC addresses, and forward frames based on destination MAC addresses.'
          },
          {
            id: 'd0000000-0000-0000-0307-000000000004',
            order_index: 4,
            marks: 10,
            question_text: 'What is the size of a standard hardware Media Access Control (MAC) address?',
            options: ['32 bits', '48 bits (6 bytes)', '64 bits', '128 bits'],
            correct_option_index: 1,
            explanation: 'Standard Ethernet/Wi-Fi MAC addresses are 48 bits (6 bytes) long, represented in hexadecimal notation (e.g. 00:1A:2B:3C:4D:5E).'
          },
          {
            id: 'd0000000-0000-0000-0307-000000000005',
            order_index: 5,
            marks: 10,
            question_text: 'What process prepends layer-specific headers as data moves downward through the network stack?',
            options: ['Decapsulation', 'Encapsulation', 'Demultiplexing', 'Fragmentation'],
            correct_option_index: 1,
            explanation: 'Encapsulation is the process where each descending layer wraps data from the layer above with its own protocol header.'
          },
          {
            id: 'd0000000-0000-0000-0307-000000000006',
            order_index: 6,
            marks: 10,
            question_text: 'What protocol translates a known 32-bit IPv4 address into a 48-bit physical MAC address on a local area network?',
            options: ['DNS', 'ARP (Address Resolution Protocol)', 'DHCP', 'ICMP'],
            correct_option_index: 1,
            explanation: 'ARP broadcasts an inquiry on the local network segment to find the hardware MAC address associated with a given target IP.'
          },
          {
            id: 'd0000000-0000-0000-0307-000000000007',
            order_index: 7,
            marks: 10,
            question_text: 'Which OSI layer handles data encryption, compression, and character code translation?',
            options: ['Presentation Layer', 'Session Layer', 'Application Layer', 'Transport Layer'],
            correct_option_index: 0,
            explanation: 'The Presentation Layer (Layer 6) transforms data into formats the application can accept, handling encryption, syntax translation, and compression.'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0207-000000000002',
        title: 'Application Protocols (DNS, HTTP) & Socket Programming Quiz',
        description: 'Examines recursive DNS lookup chains, DNS record types, HTTP caching headers, and socket calls.',
        time_limit_minutes: 20,
        passing_score: 70,
        questions: [
          {
            id: 'd0000000-0000-0000-0307-000000000008',
            order_index: 1,
            marks: 10,
            question_text: 'What DNS record type maps a domain hostname directly to an IPv6 address?',
            options: ['A Record', 'AAAA Record', 'CNAME Record', 'MX Record'],
            correct_option_index: 1,
            explanation: 'An A record maps a hostname to a 32-bit IPv4 address; a quad-A (AAAA) record maps to a 128-bit IPv6 address.'
          },
          {
            id: 'd0000000-0000-0000-0307-000000000009',
            order_index: 2,
            marks: 10,
            question_text: 'What transport protocol and port number does DNS standard name resolution utilize by default?',
            options: ['UDP Port 53', 'TCP Port 80', 'UDP Port 67', 'TCP Port 443'],
            correct_option_index: 0,
            explanation: 'Standard DNS queries use UDP port 53 for speed and minimal setup overhead.'
          },
          {
            id: 'd0000000-0000-0000-0307-000000000010',
            order_index: 3,
            marks: 10,
            question_text: 'In BSD Socket programming, which system call binds a socket descriptor to a specific local IP address and port number on the server?',
            options: ['connect()', 'bind()', 'listen()', 'accept()'],
            correct_option_index: 1,
            explanation: 'bind() assigns a local protocol address (IP + port) to an unnamed socket.'
          },
          {
            id: 'd0000000-0000-0000-0307-000000000011',
            order_index: 4,
            marks: 10,
            question_text: 'What does a DNS CNAME record specify?',
            options: [
              'An alias mapping one domain name to another canonical domain name.',
              'The mail exchange server for the domain.',
              'The authoritative name server.',
              'A cryptographic public key.'
            ],
            correct_option_index: 0,
            explanation: 'A Canonical Name (CNAME) record maps an alias hostname to its true canonical domain name.'
          },
          {
            id: 'd0000000-0000-0000-0307-000000000012',
            order_index: 5,
            marks: 10,
            question_text: 'What system call blocks a server thread until an incoming client connection request arrives on a listening socket?',
            options: ['accept()', 'listen()', 'bind()', 'select()'],
            correct_option_index: 0,
            explanation: 'accept() extracts the first connection request on the queue of pending connections and creates a new connected socket.'
          },
          {
            id: 'd0000000-0000-0000-0307-000000000013',
            order_index: 6,
            marks: 10,
            question_text: 'What HTTP request header allows a browser to conditionally revalidate cached assets based on modification date?',
            options: ['If-Modified-Since', 'Cache-Control', 'Set-Cookie', 'Upgrade-Insecure-Requests'],
            correct_option_index: 0,
            explanation: 'If-Modified-Since sends the cached last-modified timestamp; the server responds with 304 Not Modified if unchanged.'
          },
          {
            id: 'd0000000-0000-0000-0307-000000000014',
            order_index: 7,
            marks: 10,
            question_text: 'Why does a client query an Authoritative Nameserver rather than a Root Nameserver for the final IP mapping?',
            options: [
              'Root servers only maintain delegations to Top-Level Domain (TLD) servers; only the domain\'s Authoritative nameserver holds the actual resource records.',
              'Root servers do not speak IP.',
              'Authoritative servers have faster fiber lines.',
              'Root servers only run during maintenance windows.'
            ],
            correct_option_index: 0,
            explanation: 'The DNS hierarchy distributes records: root servers direct queries to TLD servers (.com), which direct queries to the authoritative server hosting the final record.'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0207-000000000003',
        title: 'TCP Reliability, Flow Control & Congestion Algorithms Quiz',
        description: 'Examines 3-way handshakes, sequence tracking, sliding window flow control, and AIMD congestion control.',
        time_limit_minutes: 20,
        passing_score: 70,
        questions: [
          {
            id: 'd0000000-0000-0000-0307-000000000015',
            order_index: 1,
            marks: 10,
            question_text: 'What is the exact sequence of TCP flag packets exchanged during the 3-Way Handshake to establish a connection?',
            options: [
              'SYN -> SYN-ACK -> ACK',
              'ACK -> SYN -> SYN-ACK',
              'SYN -> ACK -> DATA',
              'FIN -> ACK -> FIN-ACK'
            ],
            correct_option_index: 0,
            explanation: 'Client sends SYN; server responds with SYN-ACK; client acknowledges with ACK, synchronizing initial sequence numbers.'
          },
          {
            id: 'd0000000-0000-0000-0307-000000000016',
            order_index: 2,
            marks: 10,
            question_text: 'What does the Acknowledgment Number in a TCP header indicate?',
            options: [
              'The next sequence number byte the receiver expects to receive.',
              'The number of packets dropped so far.',
              'The checksum of the payload.',
              'The size of the receiver buffer.'
            ],
            correct_option_index: 0,
            explanation: 'TCP utilizes cumulative acknowledgments: ack number X indicates that all bytes up to X - 1 have been received, and the receiver expects byte X next.'
          },
          {
            id: 'd0000000-0000-0000-0307-000000000017',
            order_index: 3,
            marks: 10,
            question_text: 'How does the TCP Congestion Window (cwnd) grow during the Slow Start phase?',
            options: [
              'Exponentially: doubles every Round Trip Time (RTT).',
              'Linearly: increases by 1 MSS per RTT.',
              'Logarithmically.',
              'It remains constant.'
            ],
            correct_option_index: 0,
            explanation: 'During Slow Start, cwnd increases by 1 MSS for every acknowledged packet, effectively doubling the window every round trip time.'
          },
          {
            id: 'd0000000-0000-0000-0307-000000000018',
            order_index: 4,
            marks: 10,
            question_text: 'What event triggers the Fast Retransmit algorithm in modern TCP without waiting for a retransmission timer timeout?',
            options: [
              'Receipt of 3 Duplicate ACKs for the same sequence number.',
              'A ping command from the user.',
              'Receipt of an ICMP redirect message.',
              'A checksum error in the header.'
            ],
            correct_option_index: 0,
            explanation: 'Three duplicate ACKs indicate that subsequent out-of-order packets reached the receiver, proving a specific packet was lost and triggering immediate retransmission.'
          },
          {
            id: 'd0000000-0000-0000-0307-000000000019',
            order_index: 5,
            marks: 10,
            question_text: 'What is the purpose of the TIME_WAIT state in the TCP connection teardown protocol?',
            options: [
              'To allow lingering duplicate segments to expire in the network and ensure the final ACK was received by the remote endpoint.',
              'To download pending file updates.',
              'To renegotiate encryption keys.',
              'To save power in the NIC card.'
            ],
            correct_option_index: 0,
            explanation: 'TIME_WAIT holds the socket for 2 MSL to prevent delayed duplicate packets from being misdelivered to a subsequent connection reusing the same port pair.'
          },
          {
            id: 'd0000000-0000-0000-0307-000000000020',
            order_index: 6,
            marks: 10,
            question_text: 'How does Flow Control differ fundamentally from Congestion Control in TCP?',
            options: [
              'Flow control prevents the sender from overwhelming the receiver buffer; congestion control prevents all senders from overwhelming intermediate network links and routers.',
              'Flow control is in UDP; congestion control is in TCP.',
              'Flow control manages IP routing; congestion control manages MAC addresses.',
              'There is no difference.'
            ],
            correct_option_index: 0,
            explanation: 'Flow control is an end-to-end mechanism based on receiver advertised window (rwnd); congestion control dynamically adjusts to network bottleneck capacity.'
          },
          {
            id: 'd0000000-0000-0000-0307-000000000021',
            order_index: 7,
            marks: 10,
            question_text: 'What is the Additive Increase Multiplicative Decrease (AIMD) algorithm\'s response when packet loss occurs in Congestion Avoidance?',
            options: [
              'Halve the congestion window (Multiplicative Decrease).',
              'Reset the congestion window to 0.',
              'Double the congestion window.',
              'Increase the time quantum by 10ms.'
            ],
            correct_option_index: 0,
            explanation: 'AIMD cuts the congestion window in half upon packet loss (multiplicative decrease) and increases it by 1 MSS per RTT when successful (additive increase).'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0207-000000000004',
        title: 'IP Addressing, Subnetting, CIDR & Routing Protocols Quiz',
        description: 'Tests subnet mask calculations, CIDR prefixes, host capacity, OSPF link-state, and BGP concepts.',
        time_limit_minutes: 20,
        passing_score: 70,
        questions: [
          {
            id: 'd0000000-0000-0000-0307-000000000022',
            order_index: 1,
            marks: 10,
            question_text: 'How many usable host IP addresses are available in a subnet with prefix length /28?',
            options: ['14', '16', '30', '6'],
            correct_option_index: 0,
            explanation: 'Host bits = 32 - 28 = 4. Total IPs = 2^4 = 16. Usable host addresses = 16 - 2 (network ID & broadcast) = 14.'
          },
          {
            id: 'd0000000-0000-0000-0307-000000000023',
            order_index: 2,
            marks: 10,
            question_text: 'What is the directed broadcast address for the subnet containing IP 192.168.1.100 with mask 255.255.255.192 (/26)?',
            options: ['192.168.1.127', '192.168.1.255', '192.168.1.63', '192.168.1.128'],
            correct_option_index: 0,
            explanation: 'Block size is 64. Subnet ranges are 0-63, 64-127. IP 192.168.1.100 belongs to the 192.168.1.64 network; its broadcast address is 192.168.1.127.'
          },
          {
            id: 'd0000000-0000-0000-0307-000000000024',
            order_index: 3,
            marks: 10,
            question_text: 'Which routing protocol uses Dijkstra\'s algorithm to compute shortest path trees over a full topology link-state database?',
            options: ['OSPF (Open Shortest Path First)', 'RIP (Routing Information Protocol)', 'BGP (Border Gateway Protocol)', 'EGP'],
            correct_option_index: 0,
            explanation: 'OSPF routers exchange link-state advertisements (LSAs) and run Dijkstra\'s algorithm independently to find the shortest path tree.'
          },
          {
            id: 'd0000000-0000-0000-0307-000000000025',
            order_index: 4,
            marks: 10,
            question_text: 'Which IP address range is designated as private and unroutable on the public Internet under RFC 1918?',
            options: ['10.0.0.0/8', '11.0.0.0/8', '128.0.0.0/16', '200.1.1.0/24'],
            correct_option_index: 0,
            explanation: 'RFC 1918 defines private address blocks: 10.0.0.0/8, 172.16.0.0/12, and 192.168.0.0/16.'
          },
          {
            id: 'd0000000-0000-0000-0307-000000000026',
            order_index: 5,
            marks: 10,
            question_text: 'What routing metric limitation in the Routing Information Protocol (RIP) causes it to be unsuitable for large networks?',
            options: [
              'Maximum hop count limit of 15 (16 represents infinity/unreachable).',
              'Inability to run over Ethernet.',
              'Requirement for dedicated fiber lines.',
              'Lack of UDP support.'
            ],
            correct_option_index: 0,
            explanation: 'RIP uses hop count as its sole metric and caps path lengths at 15 hops to prevent infinite loops, restricting its use to small networks.'
          },
          {
            id: 'd0000000-0000-0000-0307-000000000027',
            order_index: 6,
            marks: 10,
            question_text: 'What protocol acts as the primary de facto exterior gateway routing protocol connecting Autonomous Systems across the Internet?',
            options: ['BGP (Border Gateway Protocol)', 'OSPF', 'RIP', 'IS-IS'],
            correct_option_index: 0,
            explanation: 'BGP is the standardized Exterior Gateway Protocol that exchanges routing and reachability information among Autonomous Systems globally.'
          },
          {
            id: 'd0000000-0000-0000-0307-000000000028',
            order_index: 7,
            marks: 10,
            question_text: 'What does a router decrement in the IPv4 header before forwarding a packet, dropping the packet if it reaches zero?',
            options: ['Time to Live (TTL)', 'Checksum', 'Fragment Offset', 'Header Length'],
            correct_option_index: 0,
            explanation: 'Every router decrements the 8-bit TTL field by at least 1; if TTL reaches 0, the router discards the packet and sends an ICMP Time Exceeded message, preventing routing loops.'
          }
        ]
      }
    ],
    assignments: [
      {
        id: 'd0000000-0000-0000-0407-000000000001',
        title: 'Project 1: Enterprise Campus Network Subnetting & CIDR Topology Design',
        description: `### Assignment Overview
Design a comprehensive hierarchical IPv4 addressing and subnetting architecture for a multi-building engineering campus. Allocate variable-length subnets (VLSM) from a single /16 block, minimize IP address waste, and configure routing tables.

### Deliverables
1. \`subnetting_plan.pdf\`: Complete VLSM addressing table detailing Department, Required Hosts, Allocated CIDR Prefix, Subnet Mask, Network ID, First/Last Usable IP, and Directed Broadcast.
2. \`network_topology.png\` (or diagram): Visual architectural diagram detailing router interfaces, subnets, and gateway assignments.
3. \`router_configs.txt\`: Cisco-style or Linux iproute2 configuration commands defining interface IP assignments and static default routes.

### Campus Department Requirements
- Faculty & Research Labs: 1,200 hosts.
- Student Computer Center: 600 hosts.
- Administrative Services: 250 hosts.
- Library & Digital Commons: 120 hosts.
- Data Center Infrastructure: 60 hosts.
- 6 Point-to-Point Router-to-Router Links: 2 hosts each (/30 or /31).

### Evaluation Rubric (Total: 100 Marks)
- **VLSM Calculations & Address Conservation (40 Marks)**: Mathematically flawless allocation with zero address overlap and minimal waste.
- **Subnet Table Completeness (25 Marks)**: Accurate network IDs, masks, usable host boundaries, and broadcast addresses.
- **Topology Diagram & Gateway Architecture (20 Marks)**: Clear visual representation with logical router placement.
- **Configuration Syntax & Documentation (15 Marks)**: Valid configuration commands and thorough engineering justification.`,
        due_date: '2026-11-30T23:59:59Z',
        max_marks: 100,
        allow_resubmission: true,
        is_published: true
      },
      {
        id: 'd0000000-0000-0000-0407-000000000002',
        title: 'Project 2: Python Socket Programming: Custom Reliable File Transfer Protocol over UDP',
        description: `### Assignment Overview
Implement a reliable file transfer application in Python using raw UDP sockets. Construct a custom Stop-and-Wait or Sliding Window transport protocol on top of unreliable UDP, incorporating sequence numbers, ACKs, timeouts, and checksum verification.

### Deliverables
1. \`reliable_sender.py\`: Application reading a file, packaging data into custom binary packets, transmitting over UDP, and handling timeouts and retransmissions.
2. \`reliable_receiver.py\`: Listens on a UDP port, verifies checksums, writes received data in sequence, and transmits acknowledgments.
3. \`test_simulation.md\`: Verification log testing transmission under synthetic simulated packet loss (10%, 25%) and artificial delay.

### Protocol Specifications
- **Packet Header Format**: 8-byte header containing \`SequenceNumber\` (32-bit int), \`AckNumber\` (32-bit int), and \`Checksum\` (16-bit CRC or Fletcher checksum).
- **Reliability Mechanisms**:
  - Implement dynamic retransmission timeout (RTO) or fixed timer.
  - Detect bit corruption using checksum; discard corrupted packets.
  - Handle duplicate packets caused by delayed retransmissions.

### Evaluation Rubric (Total: 100 Marks)
- **Protocol Packet Architecture & Socket Implementation (35 Marks)**: Clean binary packing/unpacking and correct UDP socket handling.
- **Reliability, Retransmission & Flow Control (35 Marks)**: Successful file transfer under synthetic 20% packet drop without data corruption.
- **Checksum Verification & Integrity Assertions (15 Marks)**: MD5/SHA-256 hash match between source and received files.
- **Code Cleanliness & Documentation (15 Marks)**: Well-structured Python code, CLI argument parsing, and test logs.`,
        due_date: '2026-12-15T23:59:59Z',
        max_marks: 100,
        allow_resubmission: true,
        is_published: true
      }
    ]
  },

  // -------------------------------------------------------------------------
  // 8. Software Engineering and Testing
  // -------------------------------------------------------------------------
  {
    id: 'd0000000-0000-0000-0000-000000000008',
    title: 'Software Engineering and Testing',
    slug: 'software-engineering-and-testing',
    description: 'Undergraduate software engineering methodologies: SDLC models (Agile, Scrum, Waterfall), requirements engineering (SRS, IEEE 830), SOLID architectural design principles, black-box and white-box test design, TDD, CI/CD automation pipelines, and code review practices.',
    category: 'Software Architecture',
    level: 'Intermediate',
    thumbnail_url: 'https://images.unsplash.com/photo-1516116211227-bbc04c979bf7?q=80&w=800&auto=format&fit=crop',
    lessons: [
      {
        id: 'd0000000-0000-0000-0108-000000000001',
        title: 'Software Development Lifecycles: Waterfall, Spiral & Agile/Scrum Frameworks',
        duration_minutes: 40,
        is_free_preview: true,
        order_index: 1,
        content: `### Learning Objectives
- Compare predictive SDLC models (Waterfall, V-Model) with adaptive iterative models (Spiral, Agile/Scrum).
- Understand the Agile Manifesto principles: individuals and interactions over processes and tools; working software over comprehensive documentation.
- Master Scrum rituals: Sprint Planning, Daily Standup, Sprint Review, and Retrospectives.

### SDLC Model Comparison
| Attribute | Waterfall | Spiral | Agile / Scrum |
| :--- | :--- | :--- | :--- |
| **Requirements** | Fixed upfront | Explored iteratively with risk analysis | Evolving, prioritized in product backlog |
| **Delivery** | Single final release | Iterative prototypes | Working increments every 1-4 weeks |
| **Risk Management** | High late-stage risk | Explicit formal risk assessment cycles | Continuous empirical feedback |
| **Best Suited For** | High-assurance stable projects | Mission-critical aerospace/defense | Rapidly evolving web & software products |

### Key Takeaways
- Scrum roles comprise Product Owner (prioritizes backlog), Scrum Master (removes blockers and coaches process), and Development Team (cross-functional builders).
- Velocity measures the average story points completed per sprint, guiding realistic capacity planning.`
      },
      {
        id: 'd0000000-0000-0000-0108-000000000002',
        title: 'Requirements Engineering: Functional/Non-Functional Specs & IEEE 830 SRS',
        duration_minutes: 45,
        is_free_preview: false,
        order_index: 2,
        content: `### Learning Objectives
- Distinguish Functional Requirements (what the system does) from Non-Functional Requirements (quality attributes: performance, security, availability).
- Author requirements adhering to INVEST criteria (Independent, Negotiable, Valuable, Estimable, Small, Testable).
- Structure an industry-standard Software Requirements Specification (SRS) following IEEE 830 standards.

### The FURPS+ Quality Model for Non-Functional Requirements
- **Functionality**: Capabilities, security, feature sets.
- **Usability**: Human factors, aesthetics, documentation, responsiveness.
- **Reliability**: Frequency of failure (MTBF), recoverability, predictability.
- **Performance**: Response time, throughput, memory consumption, latency limits.
- **Supportability**: Maintainability, testability, configurability, modularity.

### Writing Testable User Stories with Acceptance Criteria
\`\`\`
Feature: Student Course Enrollment
  As an authenticated student
  I want to enroll in an active course
  So that I can access lesson materials and quizzes

  Acceptance Criteria (Gherkin):
  Given the student is logged in and holds role "student"
  And the target course is published and has available capacity
  When the student clicks "Enroll Course"
  Then the system records the enrollment in the database
  And updates the course access status to "Enrolled"
\`\`\`

### Key Takeaways
- Ambiguous requirements cause $>50\\%$ of software defects; write quantifiable criteria (e.g. "99th percentile API latency $<200\\text{ms}$ under 1,000 req/s") rather than subjective terms like "fast".`
      },
      {
        id: 'd0000000-0000-0000-0108-000000000003',
        title: 'Software Architecture Patterns: Monolithic, Microservices & Event-Driven',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 3,
        content: `### Learning Objectives
- Evaluate trade-offs between Monolithic architectures, Microservices, and Event-Driven systems.
- Understand Conway\'s Law and domain-driven design (DDD) Bounded Contexts.
- Apply synchronous REST/gRPC vs asynchronous message queues (Kafka, RabbitMQ) in distributed architectures.

### Architecture Trade-Off Analysis
- **Monolith**: Single unified deployable unit. Extremely fast to develop initially; simple debugging; difficult to scale team boundaries or independent services horizontally.
- **Microservices**: Loosely coupled services organized around business domains. Independent deployments and localized scaling; introduces network latency, distributed transactions, and partial failure complexity.
- **Event-Driven**: Producers publish domain events to an event bus; asynchronous consumers process events independently, maximizing decoupling.

### Key Takeaways
- Premature decomposition into microservices is an anti-pattern; start with a modular monolith and carve out microservices only when organizational or scaling boundaries demand it.`
      },
      {
        id: 'd0000000-0000-0000-0108-000000000004',
        title: 'SOLID Object-Oriented Design Principles & Clean Code',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 4,
        content: `### Learning Objectives
- Apply Robert C. Martin\'s SOLID principles to eliminate software rot and code smells.
- Master Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, and Dependency Inversion.
- Refactor monolithic functions into clean, testable, decoupled classes.

### The SOLID Principles Defined
1. **Single Responsibility (SRP)**: A class should have only one reason to change.
2. **Open/Closed (OCP)**: Software entities should be open for extension, but closed for modification (using polymorphism and strategy patterns).
3. **Liskov Substitution (LSP)**: Subtypes must be substitutable for their base types without altering program correctness.
4. **Interface Segregation (ISP)**: Clients should not be forced to depend upon interfaces they do not use.
5. **Dependency Inversion (DIP)**: High-level modules should not depend on low-level modules; both should depend on abstractions (interfaces).

\`\`\`typescript
// Violating DIP: high-level order service depends directly on concrete MySQL database
// Applying DIP: OrderService depends on generic IOrderRepository interface
interface IOrderRepository {
  save(order: Order): Promise<void>;
}

class OrderService {
  constructor(private repository: IOrderRepository) {} // Injected abstraction

  async placeOrder(order: Order) {
    await this.repository.save(order);
  }
}
\`\`\`

### Key Takeaways
- High cohesion and loose coupling are the foundational hallmarks of sustainable software architecture.`
      },
      {
        id: 'd0000000-0000-0000-0108-000000000005',
        title: 'Black-Box & White-Box Testing Strategies: Equivalence, Boundary Values & Coverage',
        duration_minutes: 45,
        is_free_preview: false,
        order_index: 5,
        content: `### Learning Objectives
- Design functional black-box test suites using Equivalence Partitioning (EP) and Boundary Value Analysis (BVA).
- Measure structural white-box test coverage: Statement Coverage, Branch/Decision Coverage, and Path Coverage.
- Understand Cyclomatic Complexity $V(G) = E - N + 2P$ and its relation to linearly independent execution paths.

### Black-Box Techniques: Boundary Value Analysis
For an input field accepting integers $10 \\le x \\le 50$:
- **Equivalence Partitions**: Valid $[10, 50]$, Invalid $(<10)$, Invalid $(>50)$.
- **Boundary Test Values**: $9$ (just below), $10$ (boundary min), $11$ (just above), $49$ (just below), $50$ (boundary max), $51$ (just above).

### White-Box Coverage Hierarchy
$$\\text{Statement Coverage} \\subset \\text{Branch Coverage} \\subset \\text{Path Coverage}$$
- **Statement Coverage**: Percentage of executable source code statements executed at least once.
- **Branch Coverage**: Percentage of boolean branch outcomes (both True and False) evaluated during testing.

### Key Takeaways
- The vast majority of input validation errors cluster at boundaries; Boundary Value Analysis catches off-by-one errors efficiently.`
      },
      {
        id: 'd0000000-0000-0000-0108-000000000006',
        title: 'Test-Driven Development (TDD), Unit Testing & Mocking Frameworks',
        duration_minutes: 50,
        is_free_preview: false,
        order_index: 6,
        content: `### Learning Objectives
- Practice the Test-Driven Development (TDD) Red-Green-Refactor cycle.
- Differentiate test doubles: Dummies, Stubs, Spies, and Mocks.
- Structure unit tests using the Arrange-Act-Assert (AAA) pattern.

### The Red-Green-Refactor Cycle
1. **Red**: Write a failing unit test defining the desired behavior before writing production code.
2. **Green**: Write the minimal production code necessary to make the test pass.
3. **Refactor**: Clean up the implementation, eliminate duplication, and improve design while keeping tests green.

\`\`\`javascript
describe("GradingCalculator", () => {
  it("should calculate grade A for scores >= 90", () => {
    // Arrange
    const calculator = new GradingCalculator();
    // Act
    const grade = calculator.computeGrade(94.5);
    // Assert
    expect(grade).toBe("A");
  });
});
\`\`\`

### Key Takeaways
- Unit tests test isolated functions in memory without hitting real databases or network sockets.
- Stubs return canned responses to incoming calls; Mocks verify that specific method calls and parameters occurred.`
      },
      {
        id: 'd0000000-0000-0000-0108-000000000007',
        title: 'Continuous Integration / Continuous Delivery (CI/CD) & Quality Gates',
        duration_minutes: 45,
        is_free_preview: false,
        order_index: 7,
        content: `### Learning Objectives
- Architect automated CI/CD pipelines: Lint -> Static Analysis -> Test -> Build -> Deploy.
- Enforce pull request quality gates: Automated branch protection, test thresholds, and code coverage minimums.
- Manage modern deployment patterns: Blue-Green deployments, Canary releases, and Feature Flags.

### CI/CD Pipeline Stages
\`\`\`
Git Push ---> [ Linting (oxlint) ] ---> [ Type Check (tsc) ] ---> [ Unit Tests ] ---> [ Build Bundle ] ---> [ Deploy ]
                    |                          |                         |                     |
                  (Fail)                     (Fail)                    (Fail)                (Fail)
\`\`\`

### Deployment Strategies
- **Blue-Green**: Two identical production environments. Deploy new version to Green; run smoke tests; switch router to Green. Near zero downtime rollback.
- **Canary**: Route a small percentage ($5\\%$) of live traffic to the new version; monitor error metrics before rolling out to $100\\%$ of users.

### Key Takeaways
- Continuous Integration requires developers to merge code to the main branch frequently, validated by automated build and test runs on every pull request.`
      }
    ],
    quizzes: [
      {
        id: 'd0000000-0000-0000-0208-000000000001',
        title: 'Software Development Lifecycles & Agile Methodologies Quiz',
        description: 'Covers Waterfall, Spiral risk cycles, Agile principles, Scrum roles, and sprint rituals.',
        time_limit_minutes: 15,
        passing_score: 70,
        questions: [
          {
            id: 'd0000000-0000-0000-0308-000000000001',
            order_index: 1,
            marks: 10,
            question_text: 'What Scrum role is responsible for maximizing product value and managing the prioritized Product Backlog?',
            options: ['Scrum Master', 'Product Owner', 'Lead Developer', 'Agile Coach'],
            correct_option_index: 1,
            explanation: 'The Product Owner is solely responsible for defining user stories, ordering the product backlog, and optimizing business value delivered by the Scrum team.'
          },
          {
            id: 'd0000000-0000-0000-0308-000000000002',
            order_index: 2,
            marks: 10,
            question_text: 'Which software development process model places formal, iterative risk analysis at the core of each developmental cycle?',
            options: ['Waterfall Model', 'Spiral Model (Boehm)', 'V-Model', 'Extreme Programming'],
            correct_option_index: 1,
            explanation: 'Barry Boehm\'s Spiral Model combines iterative prototyping with formal risk evaluation phases before committing to major engineering phases.'
          },
          {
            id: 'd0000000-0000-0000-0308-000000000003',
            order_index: 3,
            marks: 10,
            question_text: 'What is the primary objective of the Sprint Retrospective ceremony in Scrum?',
            options: [
              'To inspect team processes, collaboration, and tools, and identify actionable improvements for future sprints.',
              'To demo completed features to stakeholders.',
              'To assign daily tasks to engineers.',
              'To renegotiate team member salaries.'
            ],
            correct_option_index: 0,
            explanation: 'The Sprint Retrospective occurs at the end of every sprint for the Scrum team to inspect how the sprint went and create a plan for continuous improvement.'
          },
          {
            id: 'd0000000-0000-0000-0308-000000000004',
            order_index: 4,
            marks: 10,
            question_text: 'What does the Agile Manifesto declare as more valuable than "comprehensive documentation"?',
            options: ['Processes and tools', 'Working software', 'Contract negotiation', 'Following a plan'],
            correct_option_index: 1,
            explanation: 'The Agile Manifesto values "Working software over comprehensive documentation" while still acknowledging the value of documentation.'
          },
          {
            id: 'd0000000-0000-0000-0308-000000000005',
            order_index: 5,
            marks: 10,
            question_text: 'In Scrum, what metric represents the amount of work (in story points) a development team completes during a typical sprint?',
            options: ['Burnup Rate', 'Velocity', 'Lead Time', 'Cycle Interval'],
            correct_option_index: 1,
            explanation: 'Velocity is the measure of the quantity of work completed per sprint, used by teams to estimate how much backlog can be committed in future sprints.'
          },
          {
            id: 'd0000000-0000-0000-0308-000000000006',
            order_index: 6,
            marks: 10,
            question_text: 'What is a key risk of the traditional Waterfall model when applied to projects with ambiguous, rapidly shifting requirements?',
            options: [
              'Defects and fundamental design flaws may remain undetected until late integration and testing phases, making remediation extremely costly.',
              'It requires too many daily meetings.',
              'It does not allow writing documentation.',
              'It forces developers to deploy multiple times per day.'
            ],
            correct_option_index: 0,
            explanation: 'Waterfall delays verification and client validation until the final stages, creating catastrophic risk if requirements were misunderstood at the beginning.'
          },
          {
            id: 'd0000000-0000-0000-0308-000000000007',
            order_index: 7,
            marks: 10,
            question_text: 'What is the time-boxed duration of a standard Daily Scrum (Standup) meeting?',
            options: ['15 minutes', '1 hour', '45 minutes', '5 minutes'],
            correct_option_index: 0,
            explanation: 'The Daily Scrum is time-boxed to 15 minutes to synchronize daily activities and identify impediments without devolving into architectural debates.'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0208-000000000002',
        title: 'Requirements Engineering & Architectural Patterns Quiz',
        description: 'Examines functional vs non-functional requirements, IEEE 830 standards, and monolith vs microservices trade-offs.',
        time_limit_minutes: 20,
        passing_score: 70,
        questions: [
          {
            id: 'd0000000-0000-0000-0308-000000000008',
            order_index: 1,
            marks: 10,
            question_text: 'Which of the following is a Non-Functional Requirement (NFR)?',
            options: [
              'The system shall compute student final percentages.',
              'The database API response time shall not exceed 250 milliseconds under 2,000 concurrent requests.',
              'The application shall allow users to upload PDF assignments.',
              'The system shall email password reset tokens.'
            ],
            correct_option_index: 1,
            explanation: 'Performance, response time, and concurrency constraints describe system quality attributes (Non-Functional Requirements) rather than specific feature behavior.'
          },
          {
            id: 'd0000000-0000-0000-0308-000000000009',
            order_index: 2,
            marks: 10,
            question_text: 'What does the "T" stand for in the INVEST user story evaluation framework?',
            options: ['Time-boxed', 'Testable', 'Technical', 'Traceable'],
            correct_option_index: 1,
            explanation: 'INVEST stands for Independent, Negotiable, Valuable, Estimable, Small, and Testable.'
          },
          {
            id: 'd0000000-0000-0000-0308-000000000010',
            order_index: 3,
            marks: 10,
            question_text: 'What observation does Conway\'s Law express regarding software architecture?',
            options: [
              'Organizations design systems that mirror their own communication and organizational structures.',
              'Software code doubles in size every two years.',
              'Testing always finds defects.',
              'Databases always become the bottleneck.'
            ],
            correct_option_index: 0,
            explanation: 'Conway\'s Law states: "Organizations which design systems are constrained to produce designs which are copies of the communication structures of these organizations."'
          },
          {
            id: 'd0000000-0000-0000-0308-000000000011',
            order_index: 4,
            marks: 10,
            question_text: 'What is a major architectural disadvantage of migrating from a monolith to microservices?',
            options: [
              'Increased operational complexity, network latency, distributed data consistency challenges, and complex cross-service debugging.',
              'Microservices prevent horizontal scaling.',
              'Microservices do not support databases.',
              'Microservices cannot be written in modern languages.'
            ],
            correct_option_index: 0,
            explanation: 'Microservices introduce distributed systems challenges: partial failures, network latency, tracing across services, and eventual consistency.'
          },
          {
            id: 'd0000000-0000-0000-0308-000000000012',
            order_index: 5,
            marks: 10,
            question_text: 'What is the purpose of an API Gateway in a microservices architecture?',
            options: [
              'Acts as a single entry point that routes client requests, terminates TLS, enforces authentication, and aggregates responses.',
              'Replaces the relational database.',
              'Compiles frontend TypeScript code into binary.',
              'Monitors physical CPU temperature.'
            ],
            correct_option_index: 0,
            explanation: 'An API Gateway shields internal microservices from external clients, managing cross-cutting concerns like SSL termination, rate limiting, and routing.'
          },
          {
            id: 'd0000000-0000-0000-0308-000000000013',
            order_index: 6,
            marks: 10,
            question_text: 'What standard format is widely used for specifying behavioral acceptance criteria in BDD (Behavior-Driven Development)?',
            options: ['Given-When-Then (Gherkin syntax)', 'Try-Catch-Finally', 'If-Else-Endif', 'Class-Method-Property'],
            correct_option_index: 0,
            explanation: 'Gherkin uses Given (context), When (action), and Then (expected outcome) to define unambiguous executable requirements.'
          },
          {
            id: 'd0000000-0000-0000-0308-000000000014',
            order_index: 7,
            marks: 10,
            question_text: 'What IEEE standard document provides guidelines for authoring Software Requirements Specifications (SRS)?',
            options: ['IEEE 830', 'IEEE 754', 'IEEE 802.11', 'IEEE 1003.1'],
            correct_option_index: 0,
            explanation: 'IEEE 830 is the established standard recommended practice for software requirements specifications.'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0208-000000000003',
        title: 'SOLID Design Principles & Refactoring Patterns Quiz',
        description: 'Evaluates practical application of SRP, OCP, LSP, ISP, and DIP in object-oriented software engineering.',
        time_limit_minutes: 20,
        passing_score: 70,
        questions: [
          {
            id: 'd0000000-0000-0000-0308-000000000015',
            order_index: 1,
            marks: 10,
            question_text: 'What does the Open/Closed Principle (OCP) mandate for software entities?',
            options: [
              'Classes should be open for extension, but closed for modification.',
              'All source code must be open source.',
              'Files should be closed after writing.',
              'Methods should accept an open number of arguments.'
            ],
            correct_option_index: 0,
            explanation: 'The Open/Closed Principle states that software entities (classes, modules) should be extensible without modifying their existing tested source code.'
          },
          {
            id: 'd0000000-0000-0000-0308-000000000016',
            order_index: 2,
            marks: 10,
            question_text: 'What violation of the Liskov Substitution Principle (LSP) is famously illustrated by the Rectangle-Square problem?',
            options: [
              'A Square subclass alters the behavior of setWidth/setHeight in a way that breaks invariants expected of a Rectangle superclass.',
              'Square inherits too many methods.',
              'Rectangle cannot be instantiated.',
              'A Square has four sides while a Rectangle has two.'
            ],
            correct_option_index: 0,
            explanation: 'Making Square extend Rectangle violates LSP because setting width on a Square modifies height as a side-effect, violating the Rectangle invariant.'
          },
          {
            id: 'd0000000-0000-0000-0308-000000000017',
            order_index: 3,
            marks: 10,
            question_text: 'What does the Dependency Inversion Principle (DIP) state regarding high-level and low-level modules?',
            options: [
              'High-level modules should not depend on low-level modules; both should depend on abstractions (interfaces).',
              'Subclasses must invert parent methods.',
              'Database tables should not reference foreign keys.',
              'Frontend modules should directly invoke database drivers.'
            ],
            correct_option_index: 0,
            explanation: 'DIP decouples high-level business policy from low-level implementation details by introducing interfaces that both layers depend upon.'
          },
          {
            id: 'd0000000-0000-0000-0308-000000000018',
            order_index: 4,
            marks: 10,
            question_text: 'What is the primary indicator that a class violates the Single Responsibility Principle (SRP)?',
            options: [
              'The class has multiple distinct actors or stakeholders who could request changes for different business reasons.',
              'The class contains more than 10 lines of code.',
              'The class implements an interface.',
              'The class contains unit tests.'
            ],
            correct_option_index: 0,
            explanation: 'SRP states that a class should have one, and only one, reason to change (meaning it is responsible to only one actor).'
          },
          {
            id: 'd0000000-0000-0000-0308-000000000019',
            order_index: 5,
            marks: 10,
            question_text: 'What does the Interface Segregation Principle (ISP) advise against?',
            options: [
              'Creating "fat" monolithic interfaces that force implementing classes to provide dummy implementations for methods they do not need.',
              'Using multiple interfaces in one class.',
              'Using TypeScript.',
              'Documenting interface contracts.'
            ],
            correct_option_index: 0,
            explanation: 'ISP states that many client-specific interfaces are better than one general-purpose interface, preventing clients from depending on unused methods.'
          },
          {
            id: 'd0000000-0000-0000-0308-000000000020',
            order_index: 6,
            marks: 10,
            question_text: 'What design pattern injects concrete dependencies into a class via its constructor rather than having the class instantiate them directly?',
            options: ['Dependency Injection (DI)', 'Singleton Pattern', 'Prototype Pattern', 'Adapter Pattern'],
            correct_option_index: 0,
            explanation: 'Dependency Injection passes required dependencies through constructors or setters, fulfilling the Dependency Inversion Principle.'
          },
          {
            id: 'd0000000-0000-0000-0308-000000000021',
            order_index: 7,
            marks: 10,
            question_text: 'What code smell occurs when a change to a single class forces cascading edits across dozens of unrelated classes?',
            options: ['Shotgun Surgery', 'Long Method', 'Feature Envy', 'Data Clumps'],
            correct_option_index: 0,
            explanation: 'Shotgun Surgery is the code smell where a single conceptual modification requires making small changes to many different classes across the codebase.'
          }
        ]
      },
      {
        id: 'd0000000-0000-0000-0208-000000000004',
        title: 'Verification, Validation & Test Automation Frameworks Quiz',
        description: 'Tests black-box boundary analysis, test doubles, TDD cycles, statement/branch coverage, and CI/CD pipelines.',
        time_limit_minutes: 20,
        passing_score: 70,
        questions: [
          {
            id: 'd0000000-0000-0000-0308-000000000022',
            order_index: 1,
            marks: 10,
            question_text: 'What test double provides pre-programmed canned answers to method calls during a test, but does not verify whether the calls occurred?',
            options: ['Stub', 'Mock', 'Spy', 'Dummy'],
            correct_option_index: 0,
            explanation: 'A Stub provides canned answers to calls made during the test; a Mock sets expectations on the calls themselves and verifies interactions.'
          },
          {
            id: 'd0000000-0000-0000-0308-000000000023',
            order_index: 2,
            marks: 10,
            question_text: 'What is the correct sequence of phases in the Test-Driven Development (TDD) cycle?',
            options: [
              'Red (failing test) -> Green (passing code) -> Refactor (clean code)',
              'Green -> Red -> Refactor',
              'Refactor -> Green -> Red',
              'Code -> Test -> Deploy'
            ],
            correct_option_index: 0,
            explanation: 'TDD follows Red-Green-Refactor: write a failing test first, write minimal code to pass the test, then refactor.'
          },
          {
            id: 'd0000000-0000-0000-0308-000000000024',
            order_index: 3,
            marks: 10,
            question_text: 'If a conditional statement "if (A && B)" is executed in code, what test coverage metric ensures that both the True and False outcomes of the decision were evaluated?',
            options: ['Branch / Decision Coverage', 'Statement Coverage', 'Line Coverage', 'Feature Coverage'],
            correct_option_index: 0,
            explanation: 'Branch coverage requires every decision point (e.g. if statement) to evaluate to both True and False at least once.'
          },
          {
            id: 'd0000000-0000-0000-0308-000000000025',
            order_index: 4,
            marks: 10,
            question_text: 'How does Boundary Value Analysis (BVA) test a field that accepts a percentage integer between 0 and 100 inclusive?',
            options: [
              'Tests values at and immediately surrounding the bounds: -1, 0, 1, 99, 100, 101.',
              'Tests only 0 and 100.',
              'Tests any 3 random numbers like 42, 57, 88.',
              'Tests only negative numbers.'
            ],
            correct_option_index: 0,
            explanation: 'BVA evaluates exact boundary values plus their immediate neighbors on either side of the valid range: -1, 0, 1 and 99, 100, 101.'
          },
          {
            id: 'd0000000-0000-0000-0308-000000000026',
            order_index: 5,
            marks: 10,
            question_text: 'What is a Blue-Green deployment strategy in continuous delivery?',
            options: [
              'Maintaining two identical production environments, deploying the new release to the inactive environment, validating, and cutting traffic over with near-zero downtime.',
              'Deploying only to users with blue screen monitors.',
              'Deploying on alternate days of the week.',
              'Running code without compiling.'
            ],
            correct_option_index: 0,
            explanation: 'Blue-Green deployments maintain two identical production stacks, switching traffic instantly via load balancer to eliminate deployment downtime.'
          },
          {
            id: 'd0000000-0000-0000-0308-000000000027',
            order_index: 6,
            marks: 10,
            question_text: 'What formula expresses McCabe\'s Cyclomatic Complexity V(G) for a control flow graph with E edges, N nodes, and P connected components?',
            options: ['V(G) = E - N + 2P', 'V(G) = N - E + P', 'V(G) = E * N / 2', 'V(G) = E + N - P'],
            correct_option_index: 0,
            explanation: 'McCabe\'s Cyclomatic Complexity is computed as V(G) = E - N + 2P, defining the number of linearly independent paths through the program.'
          },
          {
            id: 'd0000000-0000-0000-0308-000000000028',
            order_index: 7,
            marks: 10,
            question_text: 'What testing pattern organizes unit tests into three distinct sections?',
            options: [
              'Arrange, Act, Assert (AAA)',
              'Initialize, Execute, Terminate',
              'Given, When, If',
              'Compile, Link, Run'
            ],
            correct_option_index: 0,
            explanation: 'The AAA pattern structures unit tests cleanly: Arrange (set up inputs and mocks), Act (call the target function), Assert (verify results).'
          }
        ]
      }
    ],
    assignments: [
      {
        id: 'd0000000-0000-0000-0408-000000000001',
        title: 'Project 1: IEEE 830 Software Requirements Specification (SRS) for Campus Food Service',
        description: `### Assignment Overview
Author an industry-grade Software Requirements Specification (SRS) for a digital campus food ordering and delivery platform following the IEEE 830-1998 standard. Define comprehensive functional requirements, non-functional constraints, and visual UML use-case models.

### Deliverables
1. \`SRS_Document.pdf\`: Professional SRS document spanning 8–15 pages containing all IEEE 830 sections.
2. \`use_case_diagrams/\`: UML Use Case diagrams and sequence diagrams detailing student ordering, vendor fulfillment, and payment flows.
3. \`traceability_matrix.xlsx\`: Requirements Traceability Matrix (RTM) linking business goals to user stories and acceptance test cases.

### Document Sections Required
- Section 1: Introduction, Purpose, Scope, Definitions, and Overview.
- Section 2: Overall Description (Product Perspective, User Classes, Operating Environment, Assumptions).
- Section 3: Specific Requirements:
  - At least 12 detailed Functional Requirements with clear inputs, processing logic, and outputs.
  - At least 8 quantified Non-Functional Requirements covering FURPS+ categories (latency, availability, security, concurrent users).

### Evaluation Rubric (Total: 100 Marks)
- **IEEE 830 Structural Completeness & Professionalism (25 Marks)**: Adherence to standard sections, formal engineering tone, and thoroughness.
- **Functional Requirements Clarity & Testability (30 Marks)**: Unambiguous requirements free of subjective buzzwords, with verifiable criteria.
- **Non-Functional Requirements Quantification (25 Marks)**: Rigorous metrics (e.g. 99.9% uptime, <150ms p95 latency, PCI-DSS compliance).
- **UML Modeling & Traceability (20 Marks)**: Cohesive use case diagrams and complete requirements traceability matrix.`,
        due_date: '2026-11-30T23:59:59Z',
        max_marks: 100,
        allow_resubmission: true,
        is_published: true
      },
      {
        id: 'd0000000-0000-0000-0408-000000000002',
        title: 'Project 2: Automated Unit Testing Suite with Test-Driven Development (TDD) & CI Workflow',
        description: `### Assignment Overview
Construct a comprehensive automated unit and integration test suite for an e-commerce shopping cart and coupon engine. Apply Test-Driven Development (TDD), achieve $>90\\%$ branch coverage, and configure a continuous integration workflow.

### Deliverables
1. \`src/\`: Business logic classes (\`ShoppingCart\`, \`CouponEngine\`, \`TaxCalculator\`).
2. \`tests/\`: Test suite written in Jest, Vitest, or pytest implementing unit tests, boundary tests, and mock objects.
3. \`coverage_report.html\`: HTML test coverage report demonstrating $>90\\%$ statement and branch coverage.
4. \`.github/workflows/ci.yml\`: CI workflow configuration running linter, typecheck, and test commands on pull requests.

### Technical Requirements
- **Test Scenarios**:
  - Test discount code combinations (percentage off, flat discount, minimum order threshold).
  - Test boundary conditions (empty cart, zero quantities, negative values, expired coupons).
  - Use mock objects to isolate tax calculation dependencies and payment gateways.
- **Coverage**: Must achieve at least 90% branch coverage across all business logic modules.

### Evaluation Rubric (Total: 100 Marks)
- **TDD Test Suite Breadth & Assertions (35 Marks)**: Thorough test coverage of normal, boundary, and exceptional scenarios using AAA pattern.
- **Test Doubles & Mocking (25 Marks)**: Proper isolation of external dependencies using stubs and spies.
- **Code Coverage Metrics (20 Marks)**: Verified $>90\\%$ statement and branch coverage without artificial test inflation.
- **CI Workflow Configuration & Documentation (20 Marks)**: Working CI pipeline configuration and clear setup instructions.`,
        due_date: '2026-12-15T23:59:59Z',
        max_marks: 100,
        allow_resubmission: true,
        is_published: true
      }
    ]
  }
];
